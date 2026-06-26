// TMDS encoder: 8-bit color → 10-bit DC-balanced serial code
// Implements DVI 1.0 spec algorithm (spec page 29)
// During active video (de=1): encodes data with transition minimization
// During blanking (de=0): sends fixed control tokens encoding hsync/vsync
module tmds_encoder (
	input  wire        clk,
	input  wire  [7:0] data,
	input  wire  [1:0] c,   // control bits: {vsync,hsync} on blue channel
	input  wire        de,  // data enable: high during active pixels
	output logic [9:0] out
);
	// https://www.fpga4fun.com/files/dvi_spec-V1_0.pdf Page 29

	// Count ones in data byte to choose XOR vs XNOR encoding
	wire [3:0] Nb1s = data[0] + data[1] + data[2] + data[3] +
	                  data[4] + data[5] + data[6] + data[7];

	// Use XNOR when >4 ones (or 4 with lsb=0) to reduce transitions
	wire XNOR = (Nb1s>4'd4) || (Nb1s==4'd4 && data[0]==1'b0);
	wire [8:0] q_m = {~XNOR, q_m[6:0] ^ data[7:1] ^ {7{XNOR}}, data[0]};

	// DC balance tracking: running difference of ones vs zeros sent
	logic [3:0] balance_acc;
	wire [3:0] balance = q_m[0] + q_m[1] + q_m[2] + q_m[3] +
	                     q_m[4] + q_m[5] + q_m[6] + q_m[7] - 4'd4;
	wire balance_sign_eq = (balance[3] == balance_acc[3]);

	// Decide whether to invert q_m to keep running balance near zero
	wire invert_q_m = (balance==0 || balance_acc==0) ? ~q_m[8] : balance_sign_eq;
	wire [3:0] balance_acc_inc = balance -
	    ({q_m[8] ^ ~balance_sign_eq} & ~(balance==0 || balance_acc==0));
	wire [3:0] balance_acc_new = invert_q_m
	    ? balance_acc - balance_acc_inc
	    : balance_acc + balance_acc_inc;

	initial begin
		balance_acc = 0;
	end

	always_ff @(posedge clk) begin
		if (de) begin
			// Active pixel: output encoded, optionally inverted 10-bit word
			out <= {invert_q_m, q_m[8], q_m[7:0] ^ {8{invert_q_m}}};
			balance_acc <= balance_acc_new;
		end else begin
			// Blanking: send fixed control tokens (DVI spec defined values)
			case (c)
				2'b00: out <= 10'b1101010100;
				2'b01: out <= 10'b0010101011;
				2'b10: out <= 10'b0101010100;
				2'b11: out <= 10'b1010101011;
			endcase
			balance_acc <= 4'b0;
		end
	end
endmodule
