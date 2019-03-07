`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:06:58 02/18/2019 
// Design Name: 
// Module Name:    EX_MEMreg 
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
module EX_MEMreg(
	 input EX_WRegEn,
    input EX_WMemEn,
    input [63:0] EX_R1out,
    input [63:0] EX_R2out,
    input [4:0] EX_WReg1,
	 input [63:0] EX_Z,
	 
    output MEM_WMemEn,
    output MEM_WRegEn,
    output [63:0] MEM_R1out,
    output [63:0] MEM_R2out,
    output [4:0] MEM_WReg1,
	 output [3:0] MEM_Z,
	 
    input clk,
	 input reset
    );
	reg WRegEn;
	reg WMemEn;
	reg [63:0]R1out;
	reg [63:0]R2out;
	reg [4:0]WReg1;
	reg [63:0]Z;
	
	assign MEM_WRegEn = WRegEn;
	assign MEM_WMemEn = WMemEn;
	assign MEM_R1out = R1out;
	assign MEM_R2out = R2out;
	assign MEM_WReg1 = WReg1;
	assign MEM_Z = Z;
	
	always @(posedge clk,negedge reset)
	begin
		if(!reset)
		begin
			WRegEn <= 0;
			WMemEn <= 0;
			R1out <= 0;
			R2out <= 0;
			WReg1 <= 0;
			Z <= 0;
		end
		else
		begin
			WRegEn <= EX_WRegEn;
			WMemEn <= EX_WMemEn;
			R1out <= EX_R1out;
			R2out <= EX_R2out;
			WReg1 <= EX_WReg1;
			Z <= EX_Z;
		end
	end

endmodule
