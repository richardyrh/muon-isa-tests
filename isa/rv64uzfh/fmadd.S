# See LICENSE for license details.

#*****************************************************************************
# fmadd.S
#-----------------------------------------------------------------------------
#
# Test f[n]m{add|sub}.h and f[n]m{add|sub}.h instructions.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UF
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_FP_OP3_H( 2,  fmadd.h, 0,              0x4300, 0x3c00,     0x4100,     0x3c00 );
  TEST_FP_OP3_H( 3,  fmadd.h, 1,              0x4a9a, 0xbc00,     0xca0d,     0x3c66 );
  TEST_FP_OP3_H( 4,  fmadd.h, 0,              0xca00, 0x4000,     0xc500,     0xc000 );

  TEST_FP_OP3_H( 5, fnmadd.h, 0,              0xc300, 0x3c00,     0x4100,     0x3c00 );
  TEST_FP_OP3_H( 6, fnmadd.h, 1,              0xca9a, 0xbc00,     0xca0d,     0x3c66 );
  TEST_FP_OP3_H( 7, fnmadd.h, 0,              0x4a00, 0x4000,     0xc500,     0xc000 );

  TEST_FP_OP3_H( 8,  fmsub.h, 0,              0x3e00, 0x3c00,     0x4100,     0x3c00 );
  TEST_FP_OP3_H( 9,  fmsub.h, 1,              0x4980, 0xbc00,     0xca0d,     0x3c66 );
  TEST_FP_OP3_H(10,  fmsub.h, 0,              0xc800, 0x4000,     0xc500,     0xc000 );

  TEST_FP_OP3_H(11, fnmsub.h, 0,              0xbe00, 0x3c00,     0x4100,     0x3c00 );
  TEST_FP_OP3_H(12, fnmsub.h, 1,              0xc980, 0xbc00,     0xca0d,     0x3c66 );
  TEST_FP_OP3_H(13, fnmsub.h, 0,              0x4800, 0x4000,     0xc500,     0xc000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
