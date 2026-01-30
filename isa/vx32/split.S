# See LICENSE for license details.

#*****************************************************************************
# split.S
#-----------------------------------------------------------------------------
#
# Test div instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

# -------------------------------------
# these tests assume 8 threads per warp
# and might fail if that's not true
# -------------------------------------
  // these tests use only 1 core
  csrr t0, cid;
  csrr t1, 0xcd0; /* cluster id */
  add t0, t0, t1
  beqz t0, 2f;
  // spin for 2000 counts
  li t1, 2000;
1:
  addi t1, t1, -1;
  bgez t1, 1b;
  tohost zero;
  vx_tmc zero;
2:
  nop

  // simple split_n in one warp
  TEST_SPLIT( 2, \
    csrr t0, mhartid; \
    andi t0, t0, 1; \
    vx_split_n t1, t0; /* should push 10101010 onto stack */ \
    PUSH_STATE(0, alive); /* 10101010 executed last, aa wins */ \
1:  vx_join t1; \
    CHECK_STATE_64(0, alive, 0x0000aaaa); \
  )

  // simple split in one warp
  TEST_SPLIT( 3, \
    csrr t0, mhartid; \
    andi t0, t0, 1; \
    vx_split t1, t0;
    PUSH_STATE(0, alive); \
1:  vx_join t1; \
    CHECK_STATE_64(0, alive, 0x00005555); \
  )

  // make sure both branches executed
  TEST_SPLIT( 4, \
    li t0, 2; \
    la t1, 1f; \
    vx_wspawn t0, t1; \
1:  li t0, -1; \
    vx_tmc t0; \
    csrr t0, mhartid; \
    andi t0, t0, 1; \
    vx_split_n t1, t0; \
    csrr t2, wid; \
    bne t0, t2, 2f; \
    PUSH_STATE(0, alive); \
2:  vx_join t1; \
    BUSY_BAR(bar, 0xffff); \
    CHECK_STATE_64(0, alive, 0xaaaa5555); \
    la t0, bar; \
    sw zero, 0(t0); \
  )
  
  // same split in multiple warps
  TEST_SPLIT(5, \
    li t0, 4; \
    la t1, 1f; \
    vx_wspawn t0, t1; \
1:  li t0, -1; \
    vx_tmc t0; \
    csrr t0, mhartid; \
    andi t0, t0, 1; \
    vx_split_n t1, t0; \
    bnez t0, 2f; \
    PUSH_STATE(0, alive); \
2:  vx_join t1; \
    CHECK_STATE_64(0, alive, 0x5555555555555555); \
  )
  
  // different split in multiple warps
  TEST_SPLIT(6, \
    li t0, 4; \
    la t1, 1f; \
    vx_wspawn t0, t1; \
1:  li t0, -1; \
    vx_tmc t0; \
    csrr t0, mhartid; \
    srli t0, t0, LOG_LANES; /* warp-dependent mask */ \
    andi t0, t0, 1;
    vx_split_n t1, t0; \
    bnez t0, 2f; \
    PUSH_STATE(0, alive); \
2:  vx_join t1; \
    BUSY_BAR(bar, 0xffffffff); \
    CHECK_STATE_64(0, alive, 0xffff0000ffff); \
  )
  
  // non divergent split (all threads go same way)
  TEST_SPLIT(7, \
    li t0, 0; \
    vx_split_n t1, t0; \
    PUSH_STATE(0, alive); \
    vx_join t1; \
    CHECK_STATE_64(0, alive, 0x0000ffff); \
  )

  // non divergent split other direction
  TEST_SPLIT(8, \
    li t0, 1; \
    vx_split_n t1, t0; \
    PUSH_STATE(0, alive); \
    vx_join t1; \
    CHECK_STATE_64(0, alive, 0x0000ffff); \
  )
  
  // non full outermost thread mask
  TEST_SPLIT(9, \
    li t0, 0x0f; \
    vx_tmc t0; \
    csrr t1, tid; \
    andi t1, t1, 1; \
    vx_split_n t2, t1; \
    PUSH_STATE(0, alive); \
    vx_join t2; \
    CHECK_STATE_64(0, alive, 0x0000000a); \
  )
  
  // nested if (then - then)
  TEST_SPLIT(10, \
    csrr t0, mhartid; \
    andi t0, t0, 3; \
    sltu t0, zero, t0; \
    vx_split t7, t0; \
    beqz t0, 1f; /* exclude 0, 4, 8, 12 */ \
    PUSH_STATE(0, alive); \
    csrr t1, mhartid; \
    andi t1, t1, 1;
    vx_split t7, t1; \
    beqz t1, 2f; /* exclude 2, 6, 10, 14 */ \
    PUSH_STATE(1, alive); \
  2: vx_join t7; \
  1: vx_join t7; \
    CHECK_STATE_64(0, alive, 0x0000eeee);
    CHECK_STATE_64(1, alive, 0x0000aaaa);
  )
  
  // nested if (else - else)
  TEST_SPLIT(11, \
    csrr t0, mhartid; \
    andi t0, t0, 3; \
    sltu t0, zero, t0; \
    vx_split_n t7, t0; \
    beqz t0, 1f; /* exclude 0, 4, 8, 12 */ \
    PUSH_STATE(0, alive); \
    csrr t1, mhartid; \
    andi t1, t1, 1;
    vx_split t7, t1; \
    bnez t1, 2f; /* exclude 1, 3, 5, 7, 9, 11, 13, 15 */ \
    PUSH_STATE(1, alive); \
  2: vx_join t7; \
  1: vx_join t7; \
    CHECK_STATE_64(0, alive, 0x0000eeee);
    CHECK_STATE_64(1, alive, 0x00004444);
  )
  
  // triply nested if (then - else - (then, else))
  TEST_SPLIT(12, \
    csrr t0, mhartid; \
    andi t0, t0, 3; \
    sltu t0, zero, t0; \
    vx_split t7, t0; \
    beqz t0, 1f; /* exclude 0, 4, 8, 12 */ \
    PUSH_STATE(0, alive); \
    csrr t1, mhartid; \
    andi t1, t1, 1;
    vx_split_n t7, t1; \
    beqz t1, 2f; /* exclude 2, 6, 10, 14 */ \
    PUSH_STATE(1, alive); \
    csrr t2, mhartid; \
    slti t2, t2, 7; \
    vx_split_n t7, t2; \
    bnez t2, 4f; /* skip ge 7 */ \
    PUSH_STATE(2, alive); \
    j 3f; \
  4: \
    PUSH_STATE(3, alive); \
  3: vx_join t7; \
  2: vx_join t7; \
  1: vx_join t7; \
    CHECK_STATE_64(0, alive, 0x0000eeee);
    CHECK_STATE_64(1, alive, 0x0000aaaa);
    CHECK_STATE_64(2, alive, 0x0000aa80);
    CHECK_STATE_64(3, alive, 0x0000002a);
  )

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

alive:
    .rept 64
    .word 0x0
    .endr
bar:
    .word 0x0

RVTEST_DATA_END
