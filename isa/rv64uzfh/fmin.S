# See LICENSE for license details.

#*****************************************************************************
# fmin.S
#-----------------------------------------------------------------------------
#
# Test f{min|max}.h instructinos.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UF
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_FP_OP2_H( 2,  fmin.h, 0,     0x3c00,     0x4100,     0x3c00 );
  TEST_FP_OP2_H( 3,  fmin.h, 0,     0xe4d3,     0xe4d3,     0x3c66 );
  TEST_FP_OP2_H( 4,  fmin.h, 0,     0xe4d3,     0x3c66,     0xe4d3 );
  TEST_FP_OP2_H( 5,  fmin.h, 0,     0xe4d3,     0x7e00,     0xe4d3 );
  TEST_FP_OP2_H( 6,  fmin.h, 0,     0x0000,     0x4248,     0x0000 );
  TEST_FP_OP2_H( 7,  fmin.h, 0,     0xc000,     0xbc00,     0xc000 );

  TEST_FP_OP2_H(12,  fmax.h, 0,     0x4100,     0x4100,     0x3c00 );
  TEST_FP_OP2_H(13,  fmax.h, 0,     0x3c66,     0xe4d3,     0x3c66 );
  TEST_FP_OP2_H(14,  fmax.h, 0,     0x3c66,     0x3c66,     0xe4d3 );
  TEST_FP_OP2_H(15,  fmax.h, 0,     0xe4d3,     0x7e00,     0xe4d3 );
  TEST_FP_OP2_H(16,  fmax.h, 0,     0x4248,     0x4248,     0x0000 );
  TEST_FP_OP2_H(17,  fmax.h, 0,     0xbc00,     0xbc00,     0xc000 );

  # FMIN(hNaN, x) = x
  TEST_FP_OP2_H(20,  fmax.h, 0x10, 0x3c00, 0x7c01, 0x3c00);
  # FMIN(hNaN, hNaN) = canonical NaN
  TEST_FP_OP2_H(21,  fmax.h, 0x00, 0x7e00, 0x7e00, 0x7e00);

  # -0.0 < +0.0
  TEST_FP_OP2_H(30,  fmin.h, 0,     0x8000,     0x8000,     0x0000 );
  TEST_FP_OP2_H(31,  fmin.h, 0,     0x8000,     0x0000,     0x8000 );
  TEST_FP_OP2_H(32,  fmax.h, 0,     0x0000,     0x8000,     0x0000 );
  TEST_FP_OP2_H(33,  fmax.h, 0,     0x0000,     0x0000,     0x8000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
