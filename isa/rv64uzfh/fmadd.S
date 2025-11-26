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

  TEST_FP_OP3_H( 2,  fmadd.h, 0,              0x4060, 0x3f80,     0x4020,     0x3f80 );
  TEST_FP_OP3_H( 3,  fmadd.h, 1,              0x4154, 0xbf80,     0xc142,     0x3f8d );
  TEST_FP_OP3_H( 4,  fmadd.h, 0,              0xc140, 0x4000,     0xc0a0,     0xc000 );

  TEST_FP_OP3_H( 5, fnmadd.h, 0,              0xc060, 0x3f80,     0x4020,     0x3f80 );
  TEST_FP_OP3_H( 6, fnmadd.h, 1,              0xc154, 0xbf80,     0xc142,     0x3f8d );
  TEST_FP_OP3_H( 7, fnmadd.h, 0,              0x4140, 0x4000,     0xc0a0,     0xc000 );

  TEST_FP_OP3_H( 8,  fmsub.h, 0,              0x3fc0, 0x3f80,     0x4020,     0x3f80 );
  TEST_FP_OP3_H( 9,  fmsub.h, 1,              0x4130, 0xbf80,     0xc142,     0x3f8d );
  TEST_FP_OP3_H(10,  fmsub.h, 0,              0xc100, 0x4000,     0xc0a0,     0xc000 );

  TEST_FP_OP3_H(11, fnmsub.h, 0,              0xbfc0, 0x3f80,     0x4020,     0x3f80 );
  TEST_FP_OP3_H(12, fnmsub.h, 1,              0xc130, 0xbf80,     0xc142,     0x3f8d );
  TEST_FP_OP3_H(13, fnmsub.h, 0,              0x4100, 0x4000,     0xc0a0,     0xc000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
