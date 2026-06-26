`timescale 10ns/10ns

// VGA 640x480@60Hz timing generator
// Outputs pixel coordinates, sync signals, and gated color
module vga (
	input  wire        clk,
	input  wire  [7:0] r,
	input  wire  [7:0] g,
	input  wire  [7:0] b,
	output logic [9:0] px,
	output logic [9:0] py,
	output logic       vsync,
	output logic       hsync,
	output logic       de,
	output logic [7:0] vga_r,
	output logic [7:0] vga_g,
	output logic [7:0] vga_b
);
    initial begin
        px = 0;
        py = 0;
    end

	// 640x480@60Hz timing parameters (pixel clock = 25MHz)
	// Horizontal: 640 active + 16 front porch + 96 sync + 48 back porch = 800
	localparam HA_END = 639;
	localparam HS_STA = HA_END + 16;  // hsync starts after front porch
	localparam HS_END = HS_STA + 96;  // hsync pulse width = 96 pixels
	localparam LINE   = 799;          // total horizontal pixels per line

	// Vertical: 480 active + 10 front porch + 2 sync + 33 back porch = 525
	localparam VA_END = 479;
	localparam VS_STA = VA_END + 10;  // vsync starts after front porch
	localparam VS_END = VS_STA + 2;   // vsync pulse width = 2 lines
	localparam SCREEN = 524;          // total lines per frame

	// Sync signals are active-low; de gates color to visible area only
	always_comb begin
		hsync = ~(px >= HS_STA && px < HS_END);
		vsync = ~(py >= VS_STA && py < VS_END);
		de = (px <= HA_END && py <= VA_END);

		// Zero color outside visible area (blanking)
		vga_r = de ? r : 8'b0;
		vga_g = de ? g : 8'b0;
		vga_b = de ? b : 8'b0;
	end

	// Advance pixel counter; wrap line counter at frame end
	always_ff @(posedge clk) begin
		if (px == LINE) begin
			px <= 0;
			py <= (py == SCREEN) ? 0 : py + 1;
		end else begin
			px <= px + 1;
		end
	end
endmodule
