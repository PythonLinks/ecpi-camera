# ECPI Camera Gateware

Here is the gateware Verilog for ECPi Camera. 

The Raspberry Pi Zero generates a DPI parallel RGB signal.  The pixel clock 
is fed into the PLL, which passes is through the clock tree, and aligns the 
output with the input.  Then both the FPGA and RPi Zero are in the same clock 
domain and the input signal can be sent out through the DVI output port. 

The raspberry Pi sets all the ports with pull down or pull up
resistors, except one, which is set as a pull down in the verilog.

There is a directory with useful reference files.  The reference files
are taken from verious places.  ehxpll.v is the Lattice definition of
the primiatives.  yosys-pll.v is the default of how yosys calls
ehxpll.v pll-icepi.v is the one used by the icepi zero.

tmds_encorder.sv and 
vga2tmds.sv are ways to generate the tmds signals. 

├── README.md
├── ECPI-PLL.png
├── ecpi-pll.v
├── top.sv
└── reference-files
    ├── ehxpll.v
    ├── pll-icepi.v
    ├── pll-icepi.v~
    ├── yosys-pll.v
    ├── tmds_encoder.sv
    └── vga2tmds.sv


pll-icepi.v	
pll.v		
top.sv
ehxpll.v	
pll-new.v	tmds_encoder.sv	vga2tmds.sv
