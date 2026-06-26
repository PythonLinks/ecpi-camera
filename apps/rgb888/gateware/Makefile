# Source files shared between synthesis and simulation
SOURCE_FILES := hdl/vga.sv \
			    dvi_out.sv \

# Full file list for synthesis (adds serializer, encoder, PLL, top)
VERILOG_FILES := ${SOURCE_FILES} \
			     hdl/vga2tmds.sv \
				 hdl/tmds_encoder.sv \
				 hdl/pll.v \
				 top/top.sv \

# Subset used for linting and simulation (no PLL or top-level)
SIMULATION_FILES := ${SOURCE_FILES} \

# Output name stem and ECP5 package for the Icepi Zero board
OUTPUT := bitstream
PACKAGE := CABGA256

# GNU Make cannot handle spaces in the build path
ifneq ($(words $(CURDIR)),1)
  $(error Unsupported: GNU Make cannot build in directories containing spaces, build elsewhere: '$(CURDIR)')
endif

# Use system verilator unless VERILATOR_ROOT points to a local install
ifeq ($(VERILATOR_ROOT),)
  VERILATOR = verilator
else
  export VERILATOR_ROOT
  VERILATOR = $(VERILATOR_ROOT)/bin/verilator
endif

all: debug

# Synthesize Verilog to a technology-mapped netlist JSON via Yosys
%.json: ${VERILOG_FILES}
	rm -f ${OUTPUT}.bit ${OUTPUT}.config ${OUTPUT}.json
	yosys -p 'synth_ecp5 -top top -json $@' $^

# Place and route the netlist onto the ECP5 25k, constrained by the LPF pinmap
%.config: %.json icepi-zero.lpf
	nextpnr-ecp5 --25k --package ${PACKAGE} --lpf icepi-zero.lpf --json $< --textcfg $@ # 2> log.txt
	# cat log.txt | grep Device -A 28

# Pack the place-and-route output into a compressed bitstream
%.bit: %.config
	ecppack --compress $< $@

build: ${OUTPUT}.bit

# Flash to chip SRAM — bitstream is lost on power cycle
debug: build
	openFPGALoader -b icepi-zero ${OUTPUT}.bit

# Write bitstream to flash — persists across power cycles
install: build
	openFPGALoader -b icepi-zero ${OUTPUT}.bit --write-flash

# Write a previously built bitstream to flash without rebuilding
install-bitstream:
	openFPGALoader -b icepi-zero ${OUTPUT}.bit --write-flash

# Static lint check using Verilator (no simulation binary produced)
lint: ${SIMULATION_FILES}
	${VERILATOR} --lint-only -Wall -Wno-DECLFILENAME -Wno-WIDTHEXPAND ${SIMULATION_FILES}

# Build and run a C++ simulation with SDL3 display and VCD waveform trace
sim: ${SIMULATION_FILES}
	${VERILATOR} -cc --exe --build -Wall -Wno-DECLFILENAME -LDFLAGS "-lboost_program_options -lSDL3" \
	             -Wno-WIDTHEXPAND -Wno-fatal -O2 --trace-vcd --threads 8 -CFLAGS "-std=c++23" \
				 -j ${SIMULATION_FILES} sim/main.cpp verilated_vcd_c.cpp

help:
	echo "Usage: make [option]"
	echo "Options:"
	echo "- install: install to flash"
	echo "- debug: install to chip's temp memory (bitstream lost on power loss)"
	echo "- build: builds the bitstream"
	echo "- clean: delete all temparary files"

clean:
	rm -f $(OUTPUT).bit $(OUTPUT).config $(OUTPUT).json

.PHONY: build clean install sim lint help
