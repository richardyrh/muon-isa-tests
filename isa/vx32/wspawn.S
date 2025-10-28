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
# these tests assume 16 threads per warp
# and might fail if that's not true
# -------------------------------------

  // one warp by default
  TEST_VX( 2, 0x0000ffff, 1, alive, \
  )

  // two warps
  TEST_VX( 3, 0xffffffff, 1, alive, \
    li t0, 2; \
    la t1, 1f; \
    vx_wspawn t0, t1; \
1:  nop; \
  )

  // full amount of warps
  TEST_VX( 4, 0xffffffffffffffffULL, 1, alive, \
    li t0, 4; \
    la t1, 1f; \
    vx_wspawn t0, t1; \
1:  nop; \
  )

  // make sure pc of all warps jump to wspawn address
  TEST_VX( 5, 0xffffffffffffffffULL, 1, alive, \
    li t0, 4; \
    la t1, 1f; \
    vx_wspawn t0, t1; \
    vx_tmc zero; \
1:  nop; \
  )

  // if threads disagree, thread 0 wins
  TEST_VX( 6, 0x00000000ffffffffULL, 1, alive, \
    li t0, -1; \
    vx_tmc t0; \
    csrr t0, tid; \
    addi t0, t0, 2; /* 2 warps wins */ \
    la t1, 1f; \
    vx_wspawn t0, t1; \
    vx_tmc zero; \
1:  nop; \
  )

  // if threads disagree, first thread wins if thread 0 disabled
  TEST_VX( 7, 0x00000000fffffffcULL, 1, alive, \
    li t0, 0xfffc; \
    vx_tmc t0; \
    csrr t0, tid; \
    la t1, 1f; \
    vx_wspawn t0, t1; /* 2 warps wins again */ \
    vx_tmc zero; \
1:  nop; \
  )

  // hazard: wspawn -> tmc 
  TEST_VX( 8, 0x0001000100010001ULL, 1, alive, \
    li t0, 4; \
    la t1, 1f; \
    vx_wspawn t0, t1; \
    vx_tmc zero; \
1:  li t0, 1; \
    vx_tmc t0; \
  )

  // hazard: wspawn -> wspawn 
  TEST_VX( 9, 0x00ffffffffffffULL, 1, alive, \
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
  TEST_VX( 10, 0xffff0004ULL, 1, alive, \
    csrr t0, tid; /* tid=2 stays after tmc */ \
    la t1, 1f; \
    li t2, 4; \
    vx_tmc t2; \
    vx_wspawn t0, t1; \
1:  nop; \
  )

  // skip subsequent tests for 1 core configs
  csrr t0, 0xfc2; /* num cores */
  li t1, 1;
  beq t0, t1, pass;

  // one warp by default both cores
  TEST_VX_128T( 20, 0xffff, 0xffff, 1, alive, \
  )

  // two warps in each core
  // NOTE: behavior here differs from vortex.
  // vortex spawns 1 thread in new warps, but we enable all threads
  TEST_VX_128T( 21, 0xffffffff, 0xffffffff, 1, alive, \
    li t0, 2; \
    la t1, 1f; \
    vx_wspawn t0, t1; \
1:  nop; \
  )

  // full amount of warps
  TEST_VX_128T( 22, 0xffffffffffffffffULL, 0xffffffffffffffffULL, 1, alive, \
    li t0, 4; \
    la t1, 1f; \
    vx_wspawn t0, t1; \
1:  nop; \
  )

  // make sure pc of all warps jump to wspawn address
  TEST_VX_128T( 23, 0xffffffffffffffffULL, 0xffffffffffffffffULL, 1, alive, \
    li t0, 4; \
    la t1, 1f; \
    vx_wspawn t0, t1; \
    vx_tmc zero; \
1:  nop; \
  )

  // if threads disagree, thread 0 wins
  TEST_VX_128T( 24, 0x00000000ffffffffULL, 0x00000000ffffffffULL, 1, alive, \
    li t0, -1; \
    vx_tmc t0; \
    csrr t0, tid; \
    addi t0, t0, 2; /* 2 warps wins */ \
    la t1, 1f; \
    vx_wspawn t0, t1; \
    vx_tmc zero; \
1:  nop; \
  )

  // if threads disagree, first thread wins if thread 0 disabled
  TEST_VX_128T( 25, 0x00000000fffffffcULL, 0x00000000fffffffcULL, 1, alive, \
    li t0, 0xfffc; \
    vx_tmc t0; \
    csrr t0, tid; \
    la t1, 1f; \
    vx_wspawn t0, t1; /* 2 warps wins again */ \
    vx_tmc zero; \
1:  nop; \
  )

  // hazard: wspawn -> tmc 
  TEST_VX_128T( 26, 0x0001000100010001ULL, 0x0001000100010001ULL, 1, alive, \
    li t0, 4; \
    la t1, 1f; \
    vx_wspawn t0, t1; \
    vx_tmc zero; \
1:  li t0, 1; \
    vx_tmc t0; \
  )

  // hazard: wspawn -> wspawn 
  TEST_VX_128T( 27, 0x00ffffffffffffULL, 0x00ffffffffffffULL, 1, alive, \
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
  TEST_VX_128T( 28, 0xffff0004ULL, 0xffff0004ULL, 1, alive, \
    csrr t0, tid; /* tid=2 stays after tmc */ \
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
