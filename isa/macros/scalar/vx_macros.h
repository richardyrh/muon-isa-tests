#ifndef __VX_MACROS_SCALAR_H
#define __VX_MACROS_SCALAR_H

#define LOG_LANES 4

#define SPIN( spin_cycles ) \
    li x11, spin_cycles; \
1:  addi x11, x11, -1; \
    bgez x11, 1b; \

// use a memory based synchronization scheme between warps
// that involves writing to its warp id byte and reading
// all bytes to see if a given amount of warps arrived.
// this location should really only be used once
#define BUSY_BAR( loc, mask ) \
    la t0, loc; \
    csrr t1, mhartid; \
    srli t1, t1, LOG_LANES; \
    add t1, t0, t1; /* my byte addr */ \
    li t2, 0xff; /* byte to store */ \
    li t3, 1; \
    li t3, (mask & 0xffffffff); /* target value lo */ \
    li t4, (mask >> 32); /* target value hi */ \
1:  sb t2, 0(t1); \
    lw t5, 0(t0); \
    bne t5, t3, 1b; \
    lw t5, 4(t0); \
    bne t5, t4, 1b; \

// this function has each active thread store to a memory location
// corresponding to their global thread id, and ensures
// all threads are done by spinning a given number of cycles
#define MARK_LIVE_SPIN( base, spin_cycles ) \
    la x11, base; \
    csrr x12, mhartid; \
    slli x12, x12, 2; \
    add x11, x11, x12; \
    li x13, 1; \
    sw x13, 0(x11); \
    SPIN(spin_cycles); \


// this function reads from the memory location stored to by
// MARK_LIVE_SPIN into a single register, with each bit corresponding
// to each thread. It copies that value to target_reg.
#define CHECK_THREADS( target_reg, num_warps, num_threads, base ) \
    li x11, num_warps; \
    la x12, 1f; \
    vx_wspawn x11, x12; /* make sure all warps are active */ \
1:  li x11, 1; \
    vx_tmc x11; \
    csrr x11, wid; \
    beqz x11, 2f; \
    vx_tmc zero; \
2:  mv x16, zero; /* at this point thread 0 of each core remains */ \
    la x11, base; \
    mv x12, zero; \
    li x13, num_threads; /* read up to 64 words */ \
3:  beq x12, x13, 4f; \
    slli x14, x12, 2; /* word offset corresponding to gtid */ \
    add x14, x11, x14; \
    lw x15, 0(x14); /* read base + 4 * i */ \
    sw zero, 0(x14); /* clear after read */ \
    andi x15, x15, 0x1; /* take bit 0 */ \
    sll x15, x15, x12; /* shift left i bits */ \
    or x16, x16, x15; /* or into result */ \
    addi x12, x12, 1; /* inc counter */ \
    j 3b; \
4:  mv target_reg, x16; /* exit */ \

#define TEST_VX_32T( testnum, result, num_warps, base, code... ) \
    TEST_CASE( testnum, x20, result, \
        li x11, num_warps; \
        la x12, 1f; \
        vx_wspawn x11, x12; \
1:      li x20, -1; \
        vx_tmc x20; \
        li  TESTNUM, testnum; \
        code; \
        MARK_LIVE_SPIN( base, 100 ) \
        CHECK_THREADS( x20, num_warps, 32, base ) \
    )

// checks 64 threads
#define TEST_VX( testnum, result, num_warps, base, code... ) \
    TEST_CASE( testnum, x20, result, \
        li x11, num_warps; \
        la x12, 1f; \
        vx_wspawn x11, x12; \
1:      li x20, -1; \
        vx_tmc x20; \
        li  TESTNUM, testnum; \
        code; \
        MARK_LIVE_SPIN( base, 200 ) \
        CHECK_THREADS( x20, num_warps, 32, (base + 128) ) \
        li  x7, (result >> 32); \
        bne x20, x7, fail; \
        CHECK_THREADS( x20, num_warps, 32, base ) \
    )

// checks 128 threads
#define TEST_VX_128T( testnum, result_hi64, result_lo64, num_warps, base, code... ) \
    TEST_CASE( testnum, x20, result_lo64, \
        li x11, num_warps; \
        la x12, 1f; \
        vx_wspawn x11, x12; \
1:      li x20, -1; \
        vx_tmc x20; \
        li  TESTNUM, testnum; \
        code; \
        MARK_LIVE_SPIN( base, 200 ) \
        CHECK_THREADS( x20, num_warps, 32, (base + 384) ) \
        li  x7, (result_hi64 >> 32); \
        bne x20, x7, fail; \
        CHECK_THREADS( x20, num_warps, 32, (base + 256) ) \
        li  x7, (result_hi64 & 0xffffffff); \
        bne x20, x7, fail; \
        CHECK_THREADS( x20, num_warps, 32, (base + 128) ) \
        li  x7, (result_lo64 >> 32); \
        bne x20, x7, fail; \
        CHECK_THREADS( x20, num_warps, 32, base ) \
    )


// requires threads=8
#define PUSH_STATE_8( idx, base ) \
    csrr x11, tmask; \
    la x12, base; \
    li x13, idx; \
    slli x13, x13, 4; \
    add x12, x12, x13; \
    csrr x13, mhartid; \
    srli x13, x13, 3; \
    add x12, x12, x13; \
    sb x11, 0(x12); \

#define PUSH_STATE( idx, base ) \
    csrr x11, tmask; \
    la x12, base; \
    li x13, idx; \
    slli x13, x13, 4; /* idx * (total threads / 8) */ \
    add x12, x12, x13; \
    csrr x13, mhartid; \
    srli x13, x13, LOG_LANES; /* round to thread 0 idx */ \
    slli x13, x13, (LOG_LANES - 3); /* 8 lanes per byte */ \
    add x12, x12, x13; \
    sh x11, 0(x12); \

#define PUSH_STATE_R( idx, base ) \
    csrr x11, tmask; \
    la x12, base; \
    mv x13, idx; \
    slli x13, x13, 4; \
    add x12, x12, x13; \
    csrr x13, mhartid; \
    srli x13, x13, LOG_LANES; /* round to thread 0 idx */ \
    slli x13, x13, (LOG_LANES - 3); /* 8 lanes per byte */ \
    add x12, x12, x13; \
    sb x11, 0(x12); \

// checks 32 threads at once
// requires threads=8
#define CHECK_STATE_32( idx, base, result ) \
    li x11, 1; \
    la x12, 1f; \
    vx_wspawn x11, x12; \
1:  li x11, 1; \
    vx_tmc x11; \
    csrr x11, wid; \
    beqz x11, 2f; \
    vx_tmc zero; \
    \
2:  la x11, base; \
    mv x12, zero; \
    la x12, base; \
    li x13, idx; \
    slli x13, x13, 4; \
    add x12, x12, x13; \
    lw x11, 0(x12); \
    sw zero, 0(x12); \
    li x7, result; \
    bne x11, x7, fail; \

#define CHECK_STATE_64( idx, base, result ) \
    li x11, 1; \
    la x12, 1f; \
    vx_wspawn x11, x12; \
1:  li x11, 1; \
    vx_tmc x11; \
    csrr x11, wid; \
    beqz x11, 2f; \
    vx_tmc zero; \
    \
2:  la x11, base; \
    mv x12, zero; \
    la x12, base; \
    li x13, idx; \
    slli x13, x13, 4; \
    add x12, x12, x13; \
    lw x11, 0(x12); \
    sw zero, 0(x12); \
    li x7, (result & 0xffffffff); \
    bne x11, x7, fail; \
    lw x11, 4(x12); \
    sw zero, 4(x12); \
    li x7, (result >> 32); \
    bne x11, x7, fail; \

#define TEST_SPLIT( testnum, code... ) \
test_ ## testnum: \
    li t0, 1; \
    la t1, 1f; \
    vx_wspawn t0, t1; \
1:  csrr t0, wid; \
    beqz t0, 2f; \
    vx_tmc zero; \
2:  li x11, -1; \
    vx_tmc x11; \
    li  TESTNUM, testnum; \
    code; \

#define TEST_BAR( testnum, num_warps, code... ) \
test_ ## testnum: \
    li t0, num_warps; \
    la t1, 1f; \
    vx_wspawn t0, t1; \
1:  csrr t0, wid; \
    li t1, num_warps; \
    blt t0, t1, 2f; \
    vx_tmc zero; \
2:  li x11, -1; \
    vx_tmc x11; \
    li  TESTNUM, testnum; \
    code; \

#endif
