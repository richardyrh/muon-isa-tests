#=======================================================================
# Makefile for riscv-tests/isa
#-----------------------------------------------------------------------

XLEN ?= 32

src_dir := .

ifeq ($(XLEN),64)
include $(src_dir)/rv64ui/Makefrag
include $(src_dir)/rv64uc/Makefrag
include $(src_dir)/rv64um/Makefrag
include $(src_dir)/rv64ua/Makefrag
include $(src_dir)/rv64uf/Makefrag
include $(src_dir)/rv64ud/Makefrag
include $(src_dir)/rv64uzfh/Makefrag
include $(src_dir)/rv64uzba/Makefrag
include $(src_dir)/rv64uzbb/Makefrag
include $(src_dir)/rv64uzbc/Makefrag
include $(src_dir)/rv64uzbs/Makefrag
include $(src_dir)/rv64si/Makefrag
include $(src_dir)/rv64ssvnapot/Makefrag
include $(src_dir)/rv64mi/Makefrag
include $(src_dir)/rv64mzicbo/Makefrag
include $(src_dir)/hypervisor/Makefrag
endif
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
MUON_SIM ?= /scratch/yrh/cyclotron/target/debug/cyclotron /scratch/yrh/cyclotron/config.toml --binary-path


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
$(info tests="$(tests)")
ifeq ($(XLEN),64)
$(eval $(call compile_template,rv64ui,-march=rv64g -mabi=lp64))
$(eval $(call compile_template,rv64uc,-march=rv64g -mabi=lp64))
$(eval $(call compile_template,rv64um,-march=rv64g -mabi=lp64))
$(eval $(call compile_template,rv64ua,-march=rv64g -mabi=lp64))
$(eval $(call compile_template,rv64uf,-march=rv64g -mabi=lp64))
$(eval $(call compile_template,rv64ud,-march=rv64g -mabi=lp64))
$(eval $(call compile_template,rv64uzfh,-march=rv64g_zfh -mabi=lp64))
$(eval $(call compile_template,rv64uzba,-march=rv64g_zba -mabi=lp64))
$(eval $(call compile_template,rv64uzbb,-march=rv64g_zbb -mabi=lp64))
$(eval $(call compile_template,rv64uzbc,-march=rv64g_zbc -mabi=lp64))
$(eval $(call compile_template,rv64uzbs,-march=rv64g_zbs -mabi=lp64))
$(eval $(call compile_template,rv64mzicbo,-march=rv64g_zicboz -mabi=lp64))
$(eval $(call compile_template,rv64si,-march=rv64g -mabi=lp64))
$(eval $(call compile_template,rv64ssvnapot,-march=rv64g -mabi=lp64))
$(eval $(call compile_template,rv64mi,-march=rv64g -mabi=lp64))
$(eval $(call compile_template,hypervisor,-march=rv64gh -mabi=lp64))
endif

tests_dump = $(addsuffix .dump, $(tests))
tests_hex = $(addsuffix .hex, $(tests))
tests_out = $(addsuffix .out, $(filter rv64%,$(tests)))
tests32_out = $(addsuffix .out32, $(filter rv32%,$(tests)))

run: $(tests_out) $(tests32_out)

junk += $(tests) $(tests_dump) $(tests_hex) $(tests_out) $(tests32_out)

#------------------------------------------------------------
# Default

all: $(tests_dump)

#------------------------------------------------------------
# Clean up

clean:
	rm -rf $(junk)
