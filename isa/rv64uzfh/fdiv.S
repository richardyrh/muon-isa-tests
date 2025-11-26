# See LICENSE for license details.

#*****************************************************************************
# fdiv.S
#-----------------------------------------------------------------------------
#
# Test f{div|sqrt}.h instructions.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UF
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_FP_OP2_H(2,  fdiv.h, 1, 0x3f94, 0x4049, 0x402e );
  TEST_FP_OP2_H(3,  fdiv.h, 0, 0xbf80, 0xc49a, 0x449a );
  TEST_FP_OP2_H(4,  fdiv.h, 0, 0x4049, 0x4049, 0x3f80 );

  TEST_FP_OP1_H(5,  fsqrt.h, 1, 0x3fe3, 0x4049 );
  TEST_FP_OP1_H(6,  fsqrt.h, 1, 0x42c8, 0x461c );

  TEST_FP_OP1_H_DWORD_RESULT(7,  fsqrt.h, 0x10, 0x00007fc0, 0xbf80 );

  TEST_FP_OP1_H(8,  fsqrt.h, 1, 0x4151, 0x432b);


  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
