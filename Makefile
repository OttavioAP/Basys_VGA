VIVADO ?= /opt/2025.1/Vivado/bin/vivado
SIM_OUT_DIR ?= sim/build
BIT_TOP ?= basys_vga
SYNTH_FILE ?=
SYNTH_TOP ?=
SYNTH_TOP_NAME := $(if $(SYNTH_TOP),$(SYNTH_TOP),$(basename $(notdir $(SYNTH_FILE))))
SYNTH_TOP_NAME := $(if $(SYNTH_TOP_NAME),$(SYNTH_TOP_NAME),pixel_clock_gen)

.PHONY: simulate bitstream synth program clean

simulate:
	mkdir -p $(SIM_OUT_DIR)
	iverilog -g2012 -DSIM -o $(SIM_OUT_DIR)/sim.out rtl/*.sv sim/*.sv
	vvp $(SIM_OUT_DIR)/sim.out

bitstream:
	MODE=bitstream TOP=$(BIT_TOP) $(VIVADO) -mode batch -source scripts/build.tcl

#make synth SYNTH_TOP=pixel_clock_gen
synth:
	MODE=synth TOP=$(SYNTH_TOP_NAME) $(VIVADO) -mode batch -source scripts/build.tcl

program:
	TOP=$(BIT_TOP) $(VIVADO) -mode batch -source scripts/program.tcl

clean:
	rm -rf build *.jou *.log sim.out *.vcd $(SIM_OUT_DIR)
