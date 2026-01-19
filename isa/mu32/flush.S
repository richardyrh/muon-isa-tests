# See LICENSE for license details.

#*****************************************************************************
# flush.S
#-----------------------------------------------------------------------------
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32U
RVTEST_CODE_BEGIN

#define NUM_THREADS 64

#define FENCE_MEM() \
  csrr t0, cid; \
  slli t0, t0, 9; \
  addi t0, t0, 0x80300; /* i=200/400, d=300/500 */ \
  sw.shared x0, 0(t0); /* doesnt matter what we write */ \
  SPIN(500); \
  vx_bar x0, 2; /* barrier 0 with two warps */

  // TODO: disable cluster 1

  // store different lines, read other core, flush, read
  TEST_CASE( 2, x0, 0, \
    csrr t0, cid; \
    xori a0, t0, 1; \
    slli t1, t0, 6; /* 64B */ \
    slli a1, a0, 6; /* other core */ \
    la t2, data; \
    add a2, t2, a1; \
    add t2, t2, t1; /* address to store */ \
    addi t3, t0, 1; /* data to store = cid + 1 */ \
    addi a3, a0, 1; \
    sw t3, 0(t2); \
    lw t4, 0(t2); \
    lw a4, 0(a2); \
    bne t4, t3, fail; /* sanity: read own store */ \
    bne a4, x0, fail; /* other store should be zero */ \
    FENCE_MEM(); \
    lw a4, 0(a2); \
    bne a4, a3, fail; /* other core store should now appear */ \
  )

  // use fence instruction instead
  TEST_CASE( 3, x0, 0, \
    csrr t0, cid; \
    xori a0, t0, 1; \
    slli t1, t0, 6; /* 64B */ \
    slli a1, a0, 6; /* other core */ \
    la t2, data2; \
    add a2, t2, a1; \
    add t2, t2, t1; /* address to store */ \
    addi t3, t0, 1; /* data to store = cid + 1 */ \
    addi a3, a0, 1; \
    sw t3, 0(t2); \
    lw t4, 0(t2); \
    lw a4, 0(a2); \
    bne t4, t3, fail; /* sanity: read own store */ \
    bne a4, x0, fail; /* other store should be zero */ \
    fence; \
    vx_bar x0, 2; /* barrier 0 with two warps */
    lw a4, 0(a2); \
    bne a4, a3, fail; /* other core store should now appear */ \
  )

  // TODO store same line different data, check equivalence

  // TODO store many lines, check all visible in reverse

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

data:
    .rept 4
    .word 0x0
    .endr
data2:
    .rept 4
    .word 0x0
    .endr

RVTEST_DATA_END

