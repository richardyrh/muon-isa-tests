# See LICENSE for license details.

#*****************************************************************************
# tmc.S
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

#define NUM_THREADS 64

  TEST_VX( 2, 0xffffffffffffffff, 4, alive, \
    li t0, -1; \
    vx_tmc t0; \
  )

  TEST_VX( 3, 0xaaaaaaaaaaaaaaaa, 4, alive, \
    li t0, 0xaaaa; \
    vx_tmc t0; \
  )

  // when mask different, default to thread 0
  TEST_VX( 4, 0x0001000100010001, 4, alive, \
    csrr t1, tid; \
    li t0, 1; \
    sll t0, t0, t1; \
    vx_tmc t0; \
  )

  // masked thread can be reactivated
  TEST_VX( 5, 0x5555555555555555, 4, alive, \
    li t0, 0xaaaa; \
    vx_tmc t0; \
    li t0, 0x5555; \
    vx_tmc t0; \
  )

  // when thread 0 is masked, default to first thread
  TEST_VX( 6, 0x0004000400040004, 4, alive, \
    li t0, 0xf0; \
    vx_tmc t0; \
    csrr t1, tid; /* 0x4 should be used */ \
    vx_tmc t1; \
  )

  // different masks between warps
  TEST_VX( 7, 0x0001000100000000, 4, alive, \
    csrr t0, wid; \
    li t1, 1; \
    sltu t0, t1, t0; /* warps 2, 3 active only */ \
    vx_tmc t0; \
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

RVTEST_DATA_END
