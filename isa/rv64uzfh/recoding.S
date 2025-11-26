# See LICENSE for license details.

#*****************************************************************************
# recoding.S
#-----------------------------------------------------------------------------
#
# Test corner cases of John Hauser's microarchitectural recoding scheme.
# There are twice as many recoded values as IEEE-754 values; some of these
# extras are redundant (e.g. Inf) and others are illegal (subnormals with
# too many bits set).
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UF
RVTEST_CODE_BEGIN

  # Make sure infinities with different mantissas compare as equal (bf16).
  la t0, minf
  flh a1, 0(t0)
  la t0, three
  flh a2, 0(t0)
  fmul.h a3, a1, a2
  TEST_CASE( 2, a0, 1, feq.h a0, a1, a2)
  TEST_CASE( 3, a0, 1, fle.h a0, a1, a2)
  TEST_CASE( 4, a0, 0, flt.h a0, a1, a2)

  # Likewise, but for zeroes.
  fcvt.h.w a1, x0
  li a0, 1
  fcvt.h.w a2, a0
  fmul.h a3, a1, a2
  TEST_CASE(5, a0, 1, feq.h a0, a1, a2)
  TEST_CASE(6, a0, 1, fle.h a0, a1, a2)
  TEST_CASE(7, a0, 0, flt.h a0, a1, a2)

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

minf: .2byte 0xff80  # -inf (bf16)
three: .2byte 0x4040 # 3.0 (bf16)

RVTEST_DATA_END
