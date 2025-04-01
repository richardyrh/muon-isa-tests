#ifndef __VX_MACROS_SCALAR_H
#define __VX_MACROS_SCALAR_H

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
    li x11, spin_cycles; \
1:  addi x11, x11, -1; \
    bgez x11, 1b; \

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
2:  mv x16, zero; /* at this point thread 0 remains */ \
    la x11, base; \
    mv x12, zero; \
    li x13, num_threads; /* read up to 64 words */ \
3:  beq x12, x13, 4f; \
    slli x14, x12, 2; \
    add x14, x11, x14; \
    lw x15, 0(x14); /* read base + 4 * i */ \
    sw zero, 0(x14); /* clear after read */ \
    andi x15, x15, 0x11; /* take bit 0 */ \
    sll x15, x15, x12; /* shift left i bits */ \
    or x16, x16, x15; /* or into result */ \
    addi x12, x12, 1; /* inc counter */ \
    j 3b; \
4:  mv target_reg, x16; /* exit */ \

#define TEST_VX( testnum, result, num_warps, total_num_threads, base, code... ) \
    TEST_CASE( testnum, x20, result, \
        li x11, num_warps; \
        la x12, 1f; \
        vx_wspawn x11, x12; \
1:      li x20, -1; \
        vx_tmc x20; \
        li  TESTNUM, testnum; \
        code; \
        MARK_LIVE_SPIN( base, 100 ) \
        CHECK_THREADS( x20, num_warps, total_num_threads, base ) \
    )


#endif
