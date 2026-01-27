VIVADO ?= /opt/2025.1/Vivado/bin/vivado
SIM_OUT_DIR ?= sim/build

simulate:
	mkdir -p $(SIM_OUT_DIR)
	iverilog -g2012 -DSIM -o $(SIM_OUT_DIR)/sim.out rtl/*.sv sim/*.sv
	vvp $(SIM_OUT_DIR)/sim.out

bitstream:
	$(VIVADO) -mode batch -source scripts/build.tcl

program:
	$(VIVADO) -mode batch -source scripts/program.tcl

clean:
	rm -rf build *.jou *.log sim.out *.vcd $(SIM_OUT_DIR)
