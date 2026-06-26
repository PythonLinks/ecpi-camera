// Serialize three TMDS channels to single-bit outputs
// Runs at 10x pixel clock; shifts one bit per TMDS cycle
// Reference: https://www.fpga4fun.com/HDMI.html
module vga2tmds (
	input  wire        clkp, // 25MHz pixel clock
	input  wire        clkt, // 250MHz TMDS bit clock (10x clkp)
	input  wire        vsync,
	input  wire        hsync,
	input  wire        de,
	input  wire  [7:0] r,
	input  wire  [7:0] g,
	input  wire  [7:0] b,
	output logic [3:0] tmds
);
	// tmds[3] carries pixel clock so the receiver PLL can lock
	assign tmds[0] = bts[0];  // blue (carries sync tokens during blanking)
	assign tmds[1] = gts[0];  // green
	assign tmds[2] = rts[0];  // red
	assign tmds[3] = clkp;    // pixel clock reference

	logic [3:0] counter;
	logic       load;
	logic [9:0] rt, gt, bt;    // 10-bit encoded words from TMDS encoders
	logic [9:0] rts, gts, bts; // shift registers; LSB drives output each cycle

	// Blue carries {vsync,hsync} as control bits during blanking
	tmds_encoder B_encode (clkp, b, {vsync, hsync}, de, bt);
	tmds_encoder G_encode (clkp, g, {2'b0},         de, gt);
	tmds_encoder R_encode (clkp, r, {2'b0},         de, rt);

	// Shift out one bit per TMDS clock; reload all three channels every 10
	always_ff @(posedge clkt) begin
		load <= (counter == 4'd9);

		// Load new word when counter wraps, otherwise shift right by 1
		rts <= load ? rt : {1'b0, rts[9:1]};
		gts <= load ? gt : {1'b0, gts[9:1]};
		bts <= load ? bt : {1'b0, bts[9:1]};

		counter <= (counter == 4'd9) ? 4'b0 : counter + 1;
	end
endmodule
