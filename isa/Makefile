#=======================================================================
# Makefile for riscv-tests/isa
#-----------------------------------------------------------------------

XLEN ?= 32

src_dir := .

include $(src_dir)/rv32ui/Makefrag
# include $(src_dir)/rv32uc/Makefrag
include $(src_dir)/rv32um/Makefrag
# include $(src_dir)/rv32ua/Makefrag
include $(src_dir)/rv32uf/Makefrag
# include $(src_dir)/rv32ud/Makefrag
# include $(src_dir)/rv32uzfh/Makefrag
# include $(src_dir)/rv32uzba/Makefrag
# include $(src_dir)/rv32uzbb/Makefrag
# include $(src_dir)/rv32uzbc/Makefrag
# include $(src_dir)/rv32uzbs/Makefrag
# include $(src_dir)/rv32si/Makefrag
# include $(src_dir)/rv32mi/Makefrag
include $(src_dir)/vx32/Makefrag
include $(src_dir)/neutrino/Makefrag
include $(src_dir)/mu32/Makefrag

default: all

#--------------------------------------------------------------------
# Build rules
#--------------------------------------------------------------------

# RISCV_PREFIX ?= riscv$(XLEN)-unknown-elf-
# MUON_CC ?= $(RISCV_PREFIX)gcc
# MUON_CC_OPTS ?= -static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles
# RISCV_OBJDUMP ?= $(RISCV_PREFIX)objdump --disassemble-all --disassemble-zeroes --section=.text --section=.text.startup --section=.text.init --section=.data
# RISCV_SIM ?= spike
MUON_INSTALL ?= $(realpath ../../llvm/llvm-muon/bin)
MUON_CC ?= $(MUON_INSTALL)/clang
MUON_CC_OPTS ?= -static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles --gcc-toolchain=$(RISCV_TOOLCHAIN_PATH)
MUON_CC_OPTS += -Xclang -target-feature -Xclang +vortex -mllvm -inline-threshold=262144 -fuse-ld=lld
MUON_OBJDUMP ?= $(MUON_INSTALL)/llvm-objdump -d
MUON_SIM ?= /scratch/yrh/cyclotron/target/debug/cyclotron /scratch/yrh/cyclotron/isa.toml --binary-path


vpath %.S $(src_dir)

#------------------------------------------------------------
# Build assembly tests

%.dump: %
	$(MUON_OBJDUMP) $< > $@

%.out: %
	$(MUON_SIM) $< 2> $@

%.out32: %
	$(MUON_SIM) $< 2> $@

define compile_template

$$($(1)_p_tests): $(1)-p-%: $(1)/%.S
	$$(MUON_CC) $(2) $$(MUON_CC_OPTS) -I$(src_dir)/../env -I$(src_dir)/macros/scalar -T$(src_dir)/../env/link.ld $$< -o $$@
$(1)_tests += $$($(1)_p_tests)

$(1)_tests_dump = $$(addsuffix .dump, $$($(1)_tests))

$(1): $$($(1)_tests_dump)

.PHONY: $(1)

tests += $$($(1)_tests)

endef

$(eval $(call compile_template,rv32ui,-march=rv32im_zfinx -mabi=ilp32))
# $(eval $(call compile_template,rv32uc,-march=rv32g -mabi=ilp32))
$(eval $(call compile_template,rv32um,-march=rv32im_zfinx -mabi=ilp32))
# $(eval $(call compile_template,rv32ua,-march=rv32g -mabi=ilp32))
$(eval $(call compile_template,rv32uf,-march=rv32im_zfinx -mabi=ilp32))
# $(eval $(call compile_template,rv32ud,-march=rv32g -mabi=ilp32))
# $(eval $(call compile_template,rv32uzfh,-march=rv32g_zfh -mabi=ilp32))
# $(eval $(call compile_template,rv32uzba,-march=rv32g_zba -mabi=ilp32))
# $(eval $(call compile_template,rv32uzbb,-march=rv32g_zbb -mabi=ilp32))
# $(eval $(call compile_template,rv32uzbc,-march=rv32g_zbc -mabi=ilp32))
# $(eval $(call compile_template,rv32uzbs,-march=rv32g_zbs -mabi=ilp32))
# $(eval $(call compile_template,rv32si,-march=rv32g -mabi=ilp32))
# $(eval $(call compile_template,rv32mi,-march=rv32g -mabi=ilp32))
$(eval $(call compile_template,vx32,-march=rv32im_zfinx -mabi=ilp32))
$(eval $(call compile_template,neutrino,-march=rv32im_zfinx -mabi=ilp32))
$(eval $(call compile_template,mu32,-march=rv32im_zfinx -mabi=ilp32))
$(info tests="$(tests)")

tests_dump = $(addsuffix .dump, $(tests))
tests_hex = $(addsuffix .hex, $(tests))
tests32_out = $(addsuffix .out32, $(tests))

run: $(tests_out) $(tests32_out)

junk += $(tests) $(tests_dump) $(tests_hex) $(tests_out) $(tests32_out)

#------------------------------------------------------------
# Default

all: $(tests_dump)

#------------------------------------------------------------
# Clean up

clean:
	rm -rf $(junk)
