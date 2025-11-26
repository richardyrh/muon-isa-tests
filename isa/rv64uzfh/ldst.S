# See LICENSE for license details.

#*****************************************************************************
# ldst.S
#-----------------------------------------------------------------------------
#
# This test verifies that flw, fld, fsw, and fsd work properly.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UF
RVTEST_CODE_BEGIN

  TEST_CASE(2, a0, 0xcafe3f80deadbeef, la a1, tdat; flh f1, 4(a1); fsh f1, 20(a1); ld a0, 16(a1))
  TEST_CASE(3, a0, 0x1337d00dabadbf80, la a1, tdat; flh f1, 0(a1); fsh f1, 24(a1); ld a0, 24(a1))

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

tdat:
.word 0x7f80bf80   # (-inf, -1.0) in bf16 halves
.word 0x3f803f80   # (1.0, 1.0)
.word 0x00000000
.word 0x80000000   # (+0.0, -0.0)
.word 0xdeadbeef
.word 0xcafebabe
.word 0xabad1dea
.word 0x1337d00d

RVTEST_DATA_END
