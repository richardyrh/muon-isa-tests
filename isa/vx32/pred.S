# See LICENSE for license details.

#*****************************************************************************
# pred.S
#-----------------------------------------------------------------------------
#
# Test div instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

# --------------------------------------
# these tests assume 16 threads per warp
# and might fail if that's not true
# --------------------------------------
  // these tests use only 1 core
  csrr t0, cid;
  beqz t0, 1f;
  vx_tmc zero;
1:
  nop

  // basic vx_pred
  TEST_SPLIT( 2, \
    csrr t0, mhartid; \
    andi t0, t0, 1; \
    vx_pred t0, zero; \
    PUSH_STATE(0, alive);
    CHECK_STATE_32(0, alive, 0x0000aaaa); \
  )

  // vx_pred_n
  TEST_SPLIT( 3, \
    csrr t0, mhartid; \
    andi t0, t0, 1; \
    vx_pred_n t0, zero; \
    PUSH_STATE(0, alive);
    CHECK_STATE_32(0, alive, 0x00005555); \
  )

  // nested vx_pred (pred - pred)
  TEST_SPLIT( 4, \
    csrr t0, mhartid; \
    andi t0, t0, 1; \
    vx_pred t0, zero; \
    csrr t1, mhartid; \
    andi t1, t1, 2; \
    srli t1, t1, 1; \
    vx_pred t1, zero;
    PUSH_STATE(0, alive);
    CHECK_STATE_32(0, alive, 0x00008888); \
  )

  // nested vx_pred (pred_n - pred_n)
  TEST_SPLIT( 5, \
    csrr t0, mhartid; \
    andi t0, t0, 1; \
    vx_pred_n t0, zero; /* exclude 1, 3, 5, 7 */ \
    csrr t1, mhartid; \
    andi t1, t1, 2; \
    srli t1, t1, 1; \
    vx_pred_n t1, zero; /* exclude 2, 6 */ \
    PUSH_STATE(0, alive);
    CHECK_STATE_32(0, alive, 0x00001111); \
  )

  // tmc -> pred
  TEST_SPLIT( 6, \
    li t0, 0xf; \
    vx_tmc t0; \
    csrr t1, mhartid; \
    andi t1, t1, 1; \
    vx_pred t1, zero; \
    PUSH_STATE(0, alive);
    CHECK_STATE_64(0, alive, 0x0000000a); \
  )

  // zero result mask case
  TEST_SPLIT( 7, \
    li t0, 0xaa; \
    vx_tmc t0; \
    PUSH_STATE(0, alive);
    csrr t0, mhartid; \
    andi t1, t0, 1; \
    addi t0, t0, 2; /* first active thread is 1, should use tmask=3 */ \
    vx_pred_n t1, t0; /* mask is 0 after this, fallback to rs2 */ \
    PUSH_STATE(1, alive);
    CHECK_STATE_64(0, alive, 0x000000aa); \
    CHECK_STATE_64(1, alive, 0x00000003); \
  )

  // zero result mask case in inner branch

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
