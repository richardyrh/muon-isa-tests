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

  TEST_FP_OP2_H( 2,  fadd.h, 0,             0x4060,     0x4020,     0x3f80 );
  TEST_FP_OP2_H( 3,  fadd.h, 1,             0xc49a,     0xc49a,     0x3f8d );
  TEST_FP_OP2_H( 4,  fadd.h, 1,             0x4049,     0x4048,     0x3c24 );

  TEST_FP_OP2_H( 5,  fsub.h, 0,             0x3fc0,     0x4020,     0x3f80 );
  TEST_FP_OP2_H( 6,  fsub.h, 1,             0xc49a,     0xc49a,     0xbf8d );
  TEST_FP_OP2_H( 7,  fsub.h, 1,             0x4049,     0x404a,     0x3c24 );

  TEST_FP_OP2_H( 8,  fmul.h, 0,             0x4020,     0x4020,     0x3f80 );
  TEST_FP_OP2_H( 9,  fmul.h, 0,             0x449a,     0xc49a,     0xbf80 );
  TEST_FP_OP2_H(10,  fmul.h, 1,             0x3f8d,     0x4130,     0x3dcd );

  # Is the canonical NaN generated for Inf - Inf?
  TEST_FP_OP2_H(11,  fsub.h, 0x10, 0x7fc0, 0x7f80, 0x7f80);

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
