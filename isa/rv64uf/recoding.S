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

#define f0 a20
#define f1 a21
#define flw lw

RVTEST_RV64UF
RVTEST_CODE_BEGIN

  # Make sure infinities with different mantissas compare as equal.
  la a0, minf
  flw f0, 0(a0)
  la a0, three
  flw f1, 0(a0)
  fmul.s f1, f1, f0
  TEST_CASE( 2, a0, 1, feq.s a0, f0, f1)
  TEST_CASE( 3, a0, 1, fle.s a0, f0, f1)
  TEST_CASE( 4, a0, 0, flt.s a0, f0, f1)

  # Likewise, but for zeroes.
  fcvt.s.w f0, x0
  li a0, 1
  fcvt.s.w f1, a0
  fmul.s f1, f1, f0
  TEST_CASE(5, a0, 1, feq.s a0, f0, f1)
  TEST_CASE(6, a0, 1, fle.s a0, f0, f1)
  TEST_CASE(7, a0, 0, flt.s a0, f0, f1)

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

minf: .float -Inf
three: .float 3.0

RVTEST_DATA_END
