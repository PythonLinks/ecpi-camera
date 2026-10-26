`default_nettype none
module top (
	input wire	   pixel_clock,
        input wire	   dpi_vsync,
        input wire	   dpi_hsync,
        input wire	   dpi_de	    
        input wire   [1:0] button,
        input wire   [7:0] dpi_red,
        input wire   [7:0] dpi_green,
        input wire   [7:0] dpi_blue,
	output logic [3:0] gpdi_dp,
	output logic [4:0] led
);

        wire tmds_clock;
        wire locked;
        ECPI_PLL pll(.clk_in(clock), 
                    .pixel_clock(pixel_clock), 
                    .tmds_clock(tmds_clock), 
                    .locked(locked));
        assign led = {0,0,0,0,locked};
 
	// Convert the signal to DVI and send over HDMI
	vga2tmds tmds_generator(
		.pixel_clock(pixel_clock), 
                .tmds_clock(tmds_clock), 
		.vsync(dpi_vsync), 
                .hsync(dpi_hsync), 
                .de(dpi_de),
		.r(dpi_red), 
                .g(dpi_green), 
                .b(dpi_blue), 
                .tmds(gpdi_dp));
endmodule
