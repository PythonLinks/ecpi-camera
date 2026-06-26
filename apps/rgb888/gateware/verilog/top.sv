module top (
	input wire	 clock,
        input wire [1:0] button,
        input wire [7:0] dpi_red,
        input wire [7:0] dpi_green,
        input wire [7:0] dpi_blue,
        input wire	 dpi_vsync,
        input wire	 dpi_hsync,
        input wire	 dpi_de;
        output logic [4:0] led,
	    
);

	// Convert the signal to DVI and send over HDMI
	vga2tmds tmds_generator(
		.clkp(clkp), .clkt(clkt), 
		.vsync(dpi_vsync), .hsync(dpi)hsync), .de(de),
		.r(vga_r), .g(vga_g), .b(vga_b), .tmds(gpdi_dp));
endmodule
