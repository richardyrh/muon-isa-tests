# See LICENSE for license details.

#*****************************************************************************
# fcmp.S
#-----------------------------------------------------------------------------
#
# Test f{eq|lt|le}.h instructions.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UF
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_FP_CMP_OP_H( 2, feq.h, 0x00, 0x0001, 0xbfae, 0xbfae)
  TEST_FP_CMP_OP_H( 3, fle.h, 0x00, 0x0001, 0xbfae, 0xbfae)
  TEST_FP_CMP_OP_H( 4, flt.h, 0x00, 0x0000, 0xbfae, 0xbfae)

  TEST_FP_CMP_OP_H( 5, feq.h, 0x00, 0x0000, 0xbfaf, 0xbfae)
  TEST_FP_CMP_OP_H( 6, fle.h, 0x00, 0x0001, 0xbfaf, 0xbfae)
  TEST_FP_CMP_OP_H( 7, flt.h, 0x00, 0x0001, 0xbfaf, 0xbfae)

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
