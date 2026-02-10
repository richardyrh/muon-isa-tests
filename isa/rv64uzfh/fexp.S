# See LICENSE for license details.

#*****************************************************************************
# fexp.S
#-----------------------------------------------------------------------------
#
# Test custom fexp.h and fnexp.h instructions.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UF
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Basic cases: -inf, -1, 0, 1, +inf
  #-------------------------------------------------------------

  TEST_FP_OP1_H( 2,  fexp.h,  0, 0x0000, 0xff80 );
  TEST_FP_OP1_H( 3,  fexp.h,  0, 0x3ebc, 0xbf80 );
  TEST_FP_OP1_H( 4,  fexp.h,  0, 0x3f80, 0x0000 );
  TEST_FP_OP1_H( 5,  fexp.h,  0, 0x402e, 0x3f80 );
  TEST_FP_OP1_H( 6,  fexp.h,  0, 0x7f80, 0x7f80 );

  TEST_FP_OP1_H( 7,  fnexp.h, 0, 0x7f80, 0xff80 );
  TEST_FP_OP1_H( 8,  fnexp.h, 0, 0x402e, 0xbf80 );
  TEST_FP_OP1_H( 9,  fnexp.h, 0, 0x3f80, 0x0000 );
  TEST_FP_OP1_H(10,  fnexp.h, 0, 0x3ebc, 0x3f80 );
  TEST_FP_OP1_H(11,  fnexp.h, 0, 0x0000, 0x7f80 );

  #-------------------------------------------------------------
  # Mix of bf16 bit patterns
  #-------------------------------------------------------------

  TEST_FP_OP1_H(12,  fexp.h,  0, 0x3fd3, 0x3f00 );
  TEST_FP_OP1_H(13,  fexp.h,  0, 0x40ec, 0x4000 );
  TEST_FP_OP1_H(14,  fexp.h,  0, 0x3e0b, 0xc000 );

  TEST_FP_OP1_H(15,  fnexp.h, 0, 0x3f1b, 0x3f00 );
  TEST_FP_OP1_H(16,  fnexp.h, 0, 0x3e0b, 0x4000 );
  TEST_FP_OP1_H(17,  fnexp.h, 0, 0x40ec, 0xc000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
