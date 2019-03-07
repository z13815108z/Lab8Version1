`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:00:46 02/18/2019 
// Design Name: 
// Module Name:    ID_EXreg 
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
module ID_EXreg(
    input ID_WRegEn,
    input ID_WMemEn,
    input [63:0] ID_R1out,
    input [63:0] ID_R2out,
    input [4:0] ID_WReg1,
    output EX_WMemEn,
    output EX_WRegEn,
    output [63:0] EX_R1out,
    output [63:0] EX_R2out,
    output [4:0] EX_WReg1,
    input clk,
	 input reset
    );
	reg WRegEn;
	reg WMemEn;
	reg [63:0]R1out;
	reg [63:0]R2out;
	reg [4:0]WReg1;
	
	assign EX_WRegEn = WRegEn;
	assign EX_WMemEn = WMemEn;
	assign EX_R1out = R1out;
	assign EX_R2out = R2out;
	assign EX_WReg1 = WReg1;
	
	always @(posedge clk,negedge reset)
	begin
		if(!reset)
		begin
			WRegEn <= 0;
			WMemEn <= 0;
			R1out <= 0;
			R2out <= 0;
			WReg1 <= 0;
		end
		else
		begin
			WRegEn <= ID_WRegEn;
			WMemEn <= ID_WMemEn;
			R1out <= ID_R1out;
			R2out <= ID_R2out;
			WReg1 <= ID_WReg1;
		end
	end

endmodule
