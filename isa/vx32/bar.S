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
  // li gp, 2;
  // wait for 1 warp
  TEST_BAR( 2, 4, \
    csrr t4, cid;
    csrr t0, wid; \
    bnez t0, 2f; \
    li t0, 100; \
1:  addi t0, t0, -1; \
    bnez t0, 1b; \
2:  vx_bar t4, 4; \
    PUSH_STATE(0, alive); \
    li t2, 2;
    vx_bar t2, 8; \
    bnez t4, 3f; \
    CHECK_STATE_64(0, alive, 0xffffffffffffffffULL); \
3:  nop; \
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
