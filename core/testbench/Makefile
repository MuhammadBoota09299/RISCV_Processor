# Verilog source files
SRC_FILES = \
	../rtl/defines/packages.sv \
	../rtl/*.sv \
	../../uart/rtl/*.sv\
    *.sv

# Include directory (relative to where make is run)
INCLUDE_DIR = ../rtl/defines

# ModelSim commands
VLIB = vlib
VLOG = vlog
VSIM = vsim

# Work library
WORK_LIB = work

# Default target
all: clean compile sim

.PHONY: all compile sim sim-gui clean

compile:
	@echo "Creating work library..."
	$(VLIB) $(WORK_LIB)
	@echo "Compiling Verilog files..."
	$(VLOG) -sv +incdir+$(INCLUDE_DIR) $(SRC_FILES)

sim: compile
	@echo "Running simulation without GUI..."
	$(VSIM) -c -do "run -all; quit" core_tb

sim-gui: compile
	@echo "Running simulation with GUI..."
	$(VSIM) -gui -voptargs="+acc" core_tb -do "wave.do";


clean:
	rm -rf $(WORK_LIB) transcript *.vcd *.wlf