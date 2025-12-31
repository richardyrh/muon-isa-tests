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

# -------------------------------------
# these tests assume 8 threads per warp
# and might fail if that's not true
# -------------------------------------

  li t0, 4;
  la t1, 1f;
  vx_wspawn t0, t1;
1:

  // wait for 1 warp
  TEST_VX( 2, 0xffffffffffffffffULL, 4, alive, \
    /* TEST_BAR( 2, 4, */ \
    li t4, 0; \
    csrr t0, wid; \
    bnez t0, 2f; \
    li t0, 100; \
1:  addi t0, t0, -1; \
    bnez t0, 1b; \
2:  vx_bar t4, 8; /* 4 warps/core, 2 cores/cluster */ \
    /* PUSH_STATE(0, alive); */ \
    /* CHECK_STATE_64(0, alive, 0xffffffffffffffffULL); */ \
  )

  // wait for 3 warps
  TEST_VX( 3, 0xffffffffffffffffULL, 4, alive, \
    li t4, 0; \
    csrr t0, wid; \
    beqz t0, 2f; \
    li t0, 300; \
1:  addi t0, t0, -1; \
    bnez t0, 1b; \
2:  vx_bar t4, 8; /* 4 warps/core, 2 cores/cluster */ \
  )

  // 4 simultaneous barriers
  TEST_VX( 4, 0xffffffffffffffffULL, 4, alive, \
    csrr t4, wid; \
    li t5, 15; \
    vx_bar t5, 8; /* try to sync up first */ \
    vx_bar t4, 2; \
    vx_bar t5, 8; \
  )

  // different barrier every core
  TEST_VX( 5, 0xffffffffffffffffULL, 4, alive, \
    csrr t4, cid; /* bar id = core id */ \
    csrr t0, wid; \
    slli t0, t0, 7; /* wait wid * 128 counts */ \
    addi t0, t0, 1; \
1:  addi t0, t0, -1; \
    bnez t0, 1b; \
    vx_bar t4, 4; /* ok to wait just for this core */ \
  )

  // multiple barriers in a core
  TEST_VX( 6, 0x0000000100000001ULL, 4, alive, \
    csrr t0, wid; \
    srli t1, t0, 1; \
    slli t0, t1, 10; /* wait (wid / 2) * 1k counts */ \
    addi t0, t0, 1; \
1:  addi t0, t0, -1; \
    bnez t0, 1b; \
    vx_bar t1, 4; /* 2 warps each core */ \
    MARK_LIVE_SPIN( alive, 200 ); \
    /* each group of 2 warps should only see themselves! */ \
    addi t2, t1, -1; /* w0, 1: ffffffff, w2, 3: 0 */ \
    xori t3, t2, -1; /* invert above */ \
    CHECK_THREADS_WMASK( x20, 0, 32, (alive + 128), 0xfffd ) /* w0, 2 check; no wspawn */ \
    bne x20, t3, fail; \
    CHECK_THREADS_WMASK( x20, 0, 32, alive, 0xfffd ) \
    bne x20, t2, fail; \
    vx_bar zero, 4; /* only 2 warps per core */
  )

  // repeat for good measure, interleaved warp patterns
  TEST_VX( 7, 0x0000000000010001ULL, 4, alive, \
    csrr t0, wid; \
    andi t1, t0, 1; \
    li t2, 1; \
    sub t1, t2, t1; \
    slli t0, t1, 10; /* wait (wid / 2) * 1k counts */ \
    addi t0, t0, 1; \
1:  addi t0, t0, -1; \
    bnez t0, 1b; \
    vx_bar t1, 4; /* 2 warps each core */ \
    MARK_LIVE_SPIN( alive, 200 ); \
    li t2, 0xffff; \
    addi t3, t1, -1; /* w0, 2: 0, w1, 3: ffffffff */ \
    xor t2, t2, t3; /* invert t2 if w1, 3 */ \
    CHECK_THREADS_WMASK( x20, 0, 32, (alive + 128), 0xfffe ) /* w0, 1 check; no wspawn */ \
    bne x20, t2, fail; \
    CHECK_THREADS_WMASK( x20, 0, 32, alive, 0xfffe ) \
    bne x20, t2, fail; \
    vx_bar zero, 4;
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
