# See LICENSE for license details.

#*****************************************************************************
# sync.S
#-----------------------------------------------------------------------------
#
# Test neutrino synchronization.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

li t0, 4;
la t1, 1f;
vx_wspawn t0, t1;
1:
/*
nu.invoke.ri.pw.sync t2, zero, zero, zero, zero, 64
nu.invokei.ri.pw.sync t2, 3, zero, zero, zero, 64
nu.invoke.rm.pt.async x5, x1, x2, x3, x4, 1
*/

li gp, 2;

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
