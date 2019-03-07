`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:22:11 02/18/2019 
// Design Name: 
// Module Name:    RegFile 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module RegFile(
	 input [4:0] r0addr,
    input [4:0] r1addr,
    input [63:0] wdata,
    input [4:0] waddr,
    input wena,
    output [63:0] r0data,
    output [63:0] r1data,
	 
	 input  [4:0] swaddr,
	 input [63:0] swdata,
	 input swena,
	 
	 output [63:0] dff,
	 input clk
    );
	reg [63:0] DFF[0:31];
	
	assign r0data = DFF[r0addr];
	assign r1data = DFF[r1addr];
	
	assign dff = DFF[swaddr];

	always @(posedge clk)
	begin
		if(wena)
		begin
			DFF[waddr] <= wdata;
		end
		if(swena)
		begin
			DFF[swaddr] <= swdata;
		end
	end

endmodule
