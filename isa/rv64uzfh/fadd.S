# See LICENSE for license details.

#*****************************************************************************
# fadd.S
#-----------------------------------------------------------------------------
#
# Test f{add|sub|mul}.h instructions.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UF
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_FP_OP2_H( 2,  fadd.h, 0,             0x4300,     0x4100,     0x3c00 );
  TEST_FP_OP2_H( 3,  fadd.h, 1,             0xe4d2,     0xe4d3,     0x3c66 );
  TEST_FP_OP2_H( 4,  fadd.h, 1,             0x4248,     0x4243,     0x211f );

  TEST_FP_OP2_H( 5,  fsub.h, 0,             0x3e00,     0x4100,     0x3c00 );
  TEST_FP_OP2_H( 6,  fsub.h, 1,             0xe4d2,     0xe4d3,     0xbc66 );
  TEST_FP_OP2_H( 7,  fsub.h, 1,             0x4248,     0x424d,     0x211f );

  TEST_FP_OP2_H( 8,  fmul.h, 0,             0x4100,     0x4100,     0x3c00 );
  TEST_FP_OP2_H( 9,  fmul.h, 0,             0x64d3,     0xe4d3,     0xbc00 );
  TEST_FP_OP2_H(10,  fmul.h, 1,             0x3c66,     0x4980,     0x2e66 );

  # Is the canonical NaN generated for Inf - Inf?
  TEST_FP_OP2_H(11,  fsub.h, 0x10, 0x7e00, 0x7c00, 0x7c00);

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
