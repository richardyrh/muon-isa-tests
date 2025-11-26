# See LICENSE for license details.

#*****************************************************************************
# fcvt.S
#-----------------------------------------------------------------------------
#
# Test fcvt.h.{wu|w|lu|l}, fcvt.h.d, and fcvt.d.h instructions.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UF
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_INT_FP_OP_H( 2,  fcvt.h.w,               0x4000,  2);
  TEST_INT_FP_OP_H( 3,  fcvt.h.w,               0xc000, -2);

  TEST_INT_FP_OP_H( 4, fcvt.h.wu,              0x4000,  2);
  TEST_INT_FP_OP_H( 5, fcvt.h.wu,              0x4f80, -2);

#if __riscv_xlen >= 64
  TEST_INT_FP_OP_H( 6,  fcvt.h.l,               0x4000,  2);
  TEST_INT_FP_OP_H( 7,  fcvt.h.l,               0xc000, -2);

  TEST_INT_FP_OP_H( 8, fcvt.h.lu,              0x4000,  2);
  TEST_INT_FP_OP_H( 9, fcvt.h.lu,              0x5f80, -2);
#endif
  
  TEST_FCVT_H_S( 10, 0xbfc0, 0xbfc0)

#if __riscv_xlen >= 64
  TEST_FCVT_H_D( 11, 0xbfc0, 0xbfc0)
#endif
  
  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
