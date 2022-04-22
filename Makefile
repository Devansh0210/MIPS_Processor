TOPLEVEL_LANG ?= verilog

PWD=$(shell pwd)

# export PYTHONPATH := $(PWD)/$(PYTHONPATH)

ifeq ($(TOPLEVEL_LANG),verilog)
    VERILOG_SOURCES = $(PWD)/mips_proc.v
else
    $(error "A valid value (verilog or vhdl) was not provided for TOPLEVEL_LANG=$(TOPLEVEL_LANG)")
endif

TOPLEVEL := MIPS_16
MODULE   := val_proc
# COCOTB_ANSI_OUTPUT=1

include $(shell cocotb-config --makefiles)/Makefile.sim