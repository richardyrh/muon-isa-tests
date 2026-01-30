// See LICENSE for license details.

#ifndef _ENV_PHYSICAL_SINGLE_CORE_H
#define _ENV_PHYSICAL_SINGLE_CORE_H

#include "encoding.h"

//-----------------------------------------------------------------------
// Begin Macro
//-----------------------------------------------------------------------

#define RVTEST_RV64U                                                    \
  .macro init;                                                          \
  .endm

#define RVTEST_RV64UF                                                   \
  .macro init;                                                          \
  RVTEST_FP_ENABLE;                                                     \
  .endm

#define RVTEST_RV64UV                                                   \
  .macro init;                                                          \
  RVTEST_VECTOR_ENABLE;                                                 \
  .endm

#define RVTEST_RV64UVX                                                  \
  .macro init;                                                          \
  RVTEST_ZVE32X_ENABLE;                                                 \
  .endm

#define RVTEST_RV32U                                                    \
  .macro init;                                                          \
  .endm

#define RVTEST_RV32UF                                                   \
  .macro init;                                                          \
  RVTEST_FP_ENABLE;                                                     \
  .endm

#define RVTEST_RV32UV                                                   \
  .macro init;                                                          \
  RVTEST_VECTOR_ENABLE;                                                 \
  .endm

#define RVTEST_RV32UVX                                                  \
  .macro init;                                                          \
  RVTEST_ZVE32X_ENABLE;                                                 \
  .endm

#define RVTEST_RV64M                                                    \
  .macro init;                                                          \
  RVTEST_ENABLE_MACHINE;                                                \
  .endm

#define RVTEST_RV64S                                                    \
  .macro init;                                                          \
  RVTEST_ENABLE_SUPERVISOR;                                             \
  .endm

#define RVTEST_RV32M                                                    \
  .macro init;                                                          \
  RVTEST_ENABLE_MACHINE;                                                \
  .endm

#define RVTEST_RV32S                                                    \
  .macro init;                                                          \
  RVTEST_ENABLE_SUPERVISOR;                                             \
  .endm

#if __riscv_xlen == 64
# define CHECK_XLEN li a0, 1; slli a0, a0, 31; bgez a0, 1f; RVTEST_PASS; 1:
#else
# define CHECK_XLEN li a0, 1; slli a0, a0, 31; bltz a0, 1f; RVTEST_PASS; 1:
#endif

#define INIT_XREG                                                       \
  li x1, 0;                                                             \
  li x2, 0;                                                             \
  li x3, 0;                                                             \
  li x4, 0;                                                             \
  li x5, 0;                                                             \
  li x6, 0;                                                             \
  li x7, 0;                                                             \
  li x8, 0;                                                             \
  li x9, 0;                                                             \
  li x10, 0;                                                            \
  li x11, 0;                                                            \
  li x12, 0;                                                            \
  li x13, 0;                                                            \
  li x14, 0;                                                            \
  li x15, 0;                                                            \
  li x16, 0;                                                            \
  li x17, 0;                                                            \
  li x18, 0;                                                            \
  li x19, 0;                                                            \
  li x20, 0;                                                            \
  li x21, 0;                                                            \
  li x22, 0;                                                            \
  li x23, 0;                                                            \
  li x24, 0;                                                            \
  li x25, 0;                                                            \
  li x26, 0;                                                            \
  li x27, 0;                                                            \
  li x28, 0;                                                            \
  li x29, 0;                                                            \
  li x30, 0;                                                            \
  li x31, 0;                                                            \
  li x32, 0;                                                            \
  li x33, 0;                                                            \
  li x34, 0;                                                            \
  li x35, 0;                                                            \
  li x36, 0;                                                            \
  li x37, 0;                                                            \
  li x38, 0;                                                            \
  li x39, 0;                                                            \
  li x40, 0;                                                            \
  li x41, 0;                                                            \
  li x42, 0;                                                            \
  li x43, 0;                                                            \
  li x44, 0;                                                            \
  li x45, 0;                                                            \
  li x46, 0;                                                            \
  li x47, 0;                                                            \
  li x48, 0;                                                            \
  li x49, 0;                                                            \
  li x50, 0;                                                            \
  li x51, 0;                                                            \
  li x52, 0;                                                            \
  li x53, 0;                                                            \
  li x54, 0;                                                            \
  li x55, 0;                                                            \
  li x56, 0;                                                            \
  li x57, 0;                                                            \
  li x58, 0;                                                            \
  li x59, 0;                                                            \
  li x60, 0;                                                            \
  li x61, 0;                                                            \
  li x62, 0;                                                            \
  li x63, 0;                                                            \
  li x64, 0;                                                            \
  li x65, 0;                                                            \
  li x66, 0;                                                            \
  li x67, 0;                                                            \
  li x68, 0;                                                            \
  li x69, 0;                                                            \
  li x70, 0;                                                            \
  li x71, 0;                                                            \
  li x72, 0;                                                            \
  li x73, 0;                                                            \
  li x74, 0;                                                            \
  li x75, 0;                                                            \
  li x76, 0;                                                            \
  li x77, 0;                                                            \
  li x78, 0;                                                            \
  li x79, 0;                                                            \
  li x80, 0;                                                            \
  li x81, 0;                                                            \
  li x82, 0;                                                            \
  li x83, 0;                                                            \
  li x84, 0;                                                            \
  li x85, 0;                                                            \
  li x86, 0;                                                            \
  li x87, 0;                                                            \
  li x88, 0;                                                            \
  li x89, 0;                                                            \
  li x90, 0;                                                            \
  li x91, 0;                                                            \
  li x92, 0;                                                            \
  li x93, 0;                                                            \
  li x94, 0;                                                            \
  li x95, 0;                                                            \
  li x96, 0;                                                            \
  li x97, 0;                                                            \
  li x98, 0;                                                            \
  li x99, 0;                                                            \
  li x100, 0;                                                            \
  li x101, 0;                                                            \
  li x102, 0;                                                            \
  li x103, 0;                                                            \
  li x104, 0;                                                            \
  li x105, 0;                                                            \
  li x106, 0;                                                            \
  li x107, 0;                                                            \
  li x108, 0;                                                            \
  li x109, 0;                                                            \
  li x110, 0;                                                            \
  li x111, 0;                                                            \
  li x112, 0;                                                            \
  li x113, 0;                                                            \
  li x114, 0;                                                            \
  li x115, 0;                                                            \
  li x116, 0;                                                            \
  li x117, 0;                                                            \
  li x118, 0;                                                            \
  li x119, 0;                                                            \
  li x120, 0;                                                            \
  li x121, 0;                                                            \
  li x122, 0;                                                            \
  li x123, 0;                                                            \
  li x124, 0;                                                            \
  li x125, 0;                                                            \
  li x126, 0;                                                            \
  li x127, 0;

#define INIT_PMP                                                        \
  la t0, 1f;                                                            \
  csrw mtvec, t0;                                                       \
  /* Set up a PMP to permit all accesses */                             \
  li t0, (1 << (31 + (__riscv_xlen / 64) * (53 - 31))) - 1;             \
  csrw pmpaddr0, t0;                                                    \
  li t0, PMP_NAPOT | PMP_R | PMP_W | PMP_X;                             \
  csrw pmpcfg0, t0;                                                     \
  .align 2;                                                             \
1:

#define INIT_RNMI                                                       \
  la t0, 1f;                                                            \
  csrw mtvec, t0;                                                       \
  csrwi CSR_MNSTATUS, MNSTATUS_NMIE;                                    \
  .align 2;                                                             \
1:

#define INIT_SATP                                                      \
  la t0, 1f;                                                            \
  csrw mtvec, t0;                                                       \
  csrwi satp, 0;                                                       \
  .align 2;                                                             \
1:

#define DELEGATE_NO_TRAPS                                               \
  csrwi mie, 0;                                                         \
  la t0, 1f;                                                            \
  csrw mtvec, t0;                                                       \
  csrwi medeleg, 0;                                                     \
  csrwi mideleg, 0;                                                     \
  .align 2;                                                             \
1:

#define RVTEST_ENABLE_SUPERVISOR                                        \
  li a0, MSTATUS_MPP & (MSTATUS_MPP >> 1);                              \
  csrs mstatus, a0;                                                     \
  li a0, SIP_SSIP | SIP_STIP;                                           \
  csrs mideleg, a0;                                                     \

#define RVTEST_ENABLE_MACHINE                                           \
  li a0, MSTATUS_MPP;                                                   \
  csrs mstatus, a0;                                                     \

#define RVTEST_FP_ENABLE                                                \
  csrwi fcsr, 0

#define RVTEST_VECTOR_ENABLE                                            \
  li a0, (MSTATUS_VS & (MSTATUS_VS >> 1)) |                             \
         (MSTATUS_FS & (MSTATUS_FS >> 1));                              \
  csrs mstatus, a0;                                                     \
  csrwi fcsr, 0;                                                        \
  csrwi vcsr, 0;

#define RVTEST_ZVE32X_ENABLE                                            \
  li a0, (MSTATUS_VS & (MSTATUS_VS >> 1));                              \
  csrs mstatus, a0;                                                     \
  csrwi vcsr, 0;

#define RISCV_MULTICORE_DISABLE                                         \
  csrr a0, mhartid;                                                     \
  1: bnez a0, 1b

#define EXTRA_TVEC_USER
#define EXTRA_TVEC_MACHINE
#define EXTRA_INIT
#define EXTRA_INIT_TIMER
#define FILTER_TRAP
#define FILTER_PAGE_FAULT

#define INTERRUPT_HANDLER j other_exception /* No interrupts should occur */

#define RVTEST_CODE_BEGIN                                               \
        .section .text.init;                                            \
        .align  6;                                                      \
        .globl _start;                                                  \
_start:                                                                 \
        /* reset vector */                                              \
        j reset_vector;                                                 \
        .align 2;                                                       \
handle_exception:                                                       \
        /* we don't know how to handle whatever the exception was */    \
  other_exception:                                                      \
        /* some unhandlable exception occurred */                       \
  1:    ori TESTNUM, TESTNUM, 1337;                                     \
  write_tohost:                                                         \
        sw TESTNUM, tohost, t5;                                         \
        sw zero, tohost + 4, t5;                                        \
        j write_tohost;                                                 \
reset_vector:                                                           \
        li t0, 1;                                                       \
        vx_tmc t0;                                                      \
        INIT_XREG;                                                      \
        li TESTNUM, 0;                                                  \
        CHECK_XLEN;                                                     \
        init;                                                           \
        EXTRA_INIT;                                                     \
        EXTRA_INIT_TIMER;                                               \
        j 1f;                                                           \
1:

//-----------------------------------------------------------------------
// End Macro
//-----------------------------------------------------------------------

#define RVTEST_CODE_END                                                 \
        unimp

//-----------------------------------------------------------------------
// Pass/Fail Macro
//-----------------------------------------------------------------------

#define RVTEST_PASS                                                     \
        fence;                                                          \
        li TESTNUM, 1;                                                  \
        li a0, 0;                                                       \
        tohost a0;                                                      \
        nop;                                                            \
        nop;

#define TESTNUM gp
#define RVTEST_FAIL                                                     \
        fence;                                                          \
1:      beqz TESTNUM, 1b;                                               \
        sll TESTNUM, TESTNUM, 1;                                        \
        or TESTNUM, TESTNUM, 1;                                         \
        addi a0, TESTNUM, 0;                                            \
        tohost a0;                                                      
        // .insn r 115, 0, 0, x0, a0, a7;

//-----------------------------------------------------------------------
// Data Section Macro
//-----------------------------------------------------------------------

#define EXTRA_DATA

#define RVTEST_DATA_BEGIN                                               \
        EXTRA_DATA                                                      \
        .pushsection .tohost,"aw",@progbits;                            \
        .align 6; .global tohost; tohost: .dword 0; .size tohost, 8;    \
        .align 6; .global fromhost; fromhost: .dword 0; .size fromhost, 8;\
        .popsection;                                                    \
        .align 4; .global begin_signature; begin_signature:

#define RVTEST_DATA_END .align 4; .global end_signature; end_signature:

#define RVTEST_SHARED_DATA_BEGIN .pushsection .shared_mem, "aw", @nobits;
#define RVTEST_SHARED_DATA_END .popsection;

#endif

