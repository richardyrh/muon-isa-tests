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

  TEST_FP_OP2_H(2,  fdiv.h, 1, 0x3c9f, 0x4248, 0x4170 );
  TEST_FP_OP2_H(3,  fdiv.h, 1, 0xbbfe, 0xe4d2, 0x64d3 );
  TEST_FP_OP2_H(4,  fdiv.h, 0, 0x4248, 0x4248, 0x3c00 );

  TEST_FP_OP1_H(5,  fsqrt.h, 1, 0x3f17, 0x4248 );
  TEST_FP_OP1_H(6,  fsqrt.h, 0, 0x5640, 0x70e2 );

  TEST_FP_OP1_H_DWORD_RESULT(7,  fsqrt.h, 0x10, 0x00007e00, 0xbc00 );

  TEST_FP_OP1_H(8,  fsqrt.h, 1, 0x4a8a, 0x5958);


  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
