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

  // one warp by default
  TEST_VX( 2, 0x000000ff, 1, 32, alive, \
  )

  // one warp by default both cores
  TEST_VX_2C( 3, 0x000000ff000000ffULL, 1, alive, \
  )

  // two warps in each core
  // NOTE: behavior here differs from vortex.
  // vortex spawns 1 thread in new warps, but we enable all threads
  TEST_VX_2C( 4, 0x0000ffff0000ffffULL, 1, alive, \
    li t0, 2; \
    la t1, 1f; \
    vx_wspawn t0, t1; \
1:  nop; \
  )

  // full amount of warps
  TEST_VX_2C( 5, 0xffffffffffffffffULL, 1, alive, \
    li t0, 4; \
    la t1, 1f; \
    vx_wspawn t0, t1; \
1:  nop; \
  )

  // make sure pc of all warps jump to wspawn address
  TEST_VX_2C( 6, 0xffffffffffffffffULL, 1, alive, \
    li t0, 4; \
    la t1, 1f; \
    vx_wspawn t0, t1; \
    vx_tmc zero; \
1:  nop; \
  )

  // if threads disagree, thread 0 wins
  TEST_VX_2C( 7, 0x0000ffff0000ffff, 1, alive, \
    li t0, -1; \
    vx_tmc t0; \
    csrr t0, tid; \
    addi t0, t0, 2; \
    la t1, 1f; \
    vx_wspawn t0, t1; \
    vx_tmc zero; \
1:  nop; \
  )

  // if threads disagree, first thread wins if thread 0 disabled
  TEST_VX_2C( 8, 0x0000fffc0000fffc, 1, alive, \
    li t0, 0xfc; \
    vx_tmc t0; \
    csrr t0, tid; \
    la t1, 1f; \
    vx_wspawn t0, t1; \
    vx_tmc zero; \
1:  nop; \
  )

  // hazard: wspawn -> tmc 
  TEST_VX_2C( 10, 0x0101010101010101ULL, 1, alive, \
    li t0, 4; \
    la t1, 1f; \
    vx_wspawn t0, t1; \
    vx_tmc zero; \
1:  li t0, 1; \
    vx_tmc t0; \
  )

  // hazard: wspawn -> wspawn 
  TEST_VX_2C( 11, 0x00ffffff00ffffffULL, 1, alive, \
    li t0, 2; \
    li t1, 3; \
    la t2, 1f; \
    la t3, 2f; \
    vx_wspawn t0, t2; \
    vx_tmc zero; \
1:  vx_wspawn t1, t3; \
2:  nop; \
  )

  // hazard: tmc -> wspawn 
  TEST_VX_2C( 12, 0x0000ff040000ff04ULL, 1, alive, \
    csrr t0, tid; \
    la t1, 1f; \
    li t2, 4; \
    vx_tmc t2; \
    vx_wspawn t0, t1; \
1:  nop; \
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
