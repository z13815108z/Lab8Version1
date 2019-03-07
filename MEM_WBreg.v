`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:09:05 02/18/2019 
// Design Name: 
// Module Name:    MEM_WBreg 
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
module MEM_WBreg(
    input MEM_WRegEn,
    input [63:0] MEM_Dout,
    input [4:0] MEM_WReg1,
	 output WB_WRegEn,
	 output [63:0] WB_Dout,
	 output [4:0]WB_WReg1,
    input clk,
	 input reset
    );
	 
	reg WRegEn;
	reg [63:0] Dout;
	reg [4:0] WReg1;
	
	assign WB_WRegEn = WRegEn;
	assign WB_Dout = Dout;
	assign WB_WReg1 = WReg1;
	
	always @(posedge clk,negedge reset)
	begin
		if(!reset)
		begin
			WRegEn <= 0;
			Dout <= 0;
			WReg1 <= 0;
		end
		else
		begin
			WRegEn <= MEM_WRegEn;
			Dout <= MEM_Dout;
			WReg1 <= MEM_WReg1;
		end
	end

endmodule
