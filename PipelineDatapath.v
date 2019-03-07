`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:31:59 02/18/2019 
// Design Name: 
// Module Name:    PipelineDatapath 
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
/*`define UDP_REG_ADDR_WIDTH 16
`define CPCI_NF2__DATA_WIDTH 16
`define PIPE_BLOCK_ADDR 1
`define PIPE_REG_ADDR_WIDTH 16
`define CPCI_NF2_DATA_WIDTH 16*/

module PipelineDatapath
   #(
      parameter DATA_WIDTH = 64,
      parameter CTRL_WIDTH = DATA_WIDTH/8,
      parameter UDP_REG_SRC_WIDTH = 2
   )
	(
	 // --- Datastream part
		input [DATA_WIDTH-1:0]					in_data,
		input [CTRL_WIDTH-1:0]					in_ctrl,
		input 										in_wr,
		output										in_rdy,
		
		output [DATA_WIDTH-1:0]					out_data,
		output [CTRL_WIDTH-1:0]					out_ctrl,
		output										out_wr,
		input											out_rdy,
	 // --- Register interface
      input                               reg_req_in,
      input                               reg_ack_in,
      input                               reg_rd_wr_L_in,
      input  [`UDP_REG_ADDR_WIDTH-1:0]    reg_addr_in,
      input  [`CPCI_NF2_DATA_WIDTH-1:0]   reg_data_in,
      input  [UDP_REG_SRC_WIDTH-1:0]      reg_src_in,

      output                              reg_req_out,
      output                              reg_ack_out,
      output                              reg_rd_wr_L_out,
      output  [`UDP_REG_ADDR_WIDTH-1:0]   reg_addr_out,
      output  [`CPCI_NF2_DATA_WIDTH-1:0]  reg_data_out,
      output  [UDP_REG_SRC_WIDTH-1:0]     reg_src_out,

      // misc
      input                                reset,
      input                                clk
		/*
		input [31:0]Address,
		input [31:0]Instruction,
		input [31:0]wdata_high,
		input [31:0]wdata_low,
		input [31:0]wctrl,
		input [31:0]dinb_low,
		input [31:0]dinb_high,
		input [31:0]ctrlb
		*/
    );
	 
	reg [8:0]InstCounter; 
	wire [31:0]instcounter;
	assign instcounter = InstCounter;

	reg start;
	wire [63:0]WB_Dout;
	wire [4:0]WB_WReg1;
	wire WB_WRegEn;
//sw reg
	wire [31:0]Address;
	wire [31:0]Instruction;
	
	wire [31:0]IF_Dout;//hw reg
	wire InstLoad;
	assign InstLoad = Address[9];
	wire [8:0]address;
	assign address = Address[8:0];
	wire [31:0]InstructionWatcher;
	
	InstructionMemory imem(.addra(InstCounter),.wea(1'b0),.douta(IF_Dout),
								.addrb(address),.dinb(Instruction),.web(!InstLoad),.doutb(InstructionWatcher),
								.clka(clk),.clkb(clk));
	
	wire [31:0]ID_Inst;
	assign ID_Inst = IF_Dout;
	
	wire ID_WRegEn;
	wire ID_WMemEn;
	wire [4:0]ID_r0addr;
	wire [4:0]ID_r1addr;
	wire [4:0]ID_WReg1;
	
	assign ID_WRegEn = ID_Inst[30];
	assign ID_WMemEn = ID_Inst[31];
	assign ID_r0addr = {2'b00,ID_Inst[29:27]};
	assign ID_r1addr = {2'b00,ID_Inst[26:24]};
	assign ID_WReg1 = {2'b00,ID_Inst[23:21]};
	
	wire [63:0]ID_r0data;
	wire [63:0]ID_r1data;
//hw reg	
	wire [31:0]regfileDFF0_high;
	wire [31:0]regfileDFF0_low;
//sw reg	

	wire [31:0]wdata_high;
	wire [31:0]wdata_low;
	wire [31:0]wctrl;
	
	
	RegFile regfile(.r0addr(ID_r0addr),.r1addr(ID_r1addr),.wdata(WB_Dout),.waddr(WB_WReg1),.wena(WB_WRegEn),.r0data(ID_r0data),.r1data(ID_r1data),
		.dff({regfileDFF0_high,regfileDFF0_low}),.clk(clk),
		.swena(wctrl[5]),.swaddr(wctrl[4:0]),.swdata({wdata_high,wdata_low}));
	
	wire EX_WMem_En;
	wire EX_WRegEn;
	wire [63:0]EX_R1out;
	wire [63:0]EX_R2out;
	wire [4:0]EX_WReg1;
	ID_EXreg id_exreg(.ID_WRegEn(ID_WRegEn),.ID_WMemEn(ID_WMemEn),.ID_R1out(ID_r0data),.ID_R2out(ID_r1data),.ID_WReg1(ID_WReg1),.EX_WMemEn(EX_WMemEn),
	.EX_WRegEn(EX_WRegEn),.EX_R1out(EX_R1out),.EX_R2out(EX_R2out),.EX_WReg1(EX_WReg1),.clk(clk),.reset(InstLoad));
	
	wire MEM_WMem_En;
	wire MEM_WRegEn;
	wire [63:0]MEM_R1out;
	wire [63:0]MEM_R2out;
	wire [4:0]MEM_WReg1;
	EX_MEMreg ex_memreg(.EX_WRegEn(EX_WRegEn),.EX_WMemEn(EX_WMemEn),.EX_R1out(EX_R1out),.EX_R2out(EX_R2out),.EX_WReg1(EX_WReg1),
	.MEM_WMemEn(MEM_WMemEn),.MEM_WRegEn(MEM_WRegEn),.MEM_R1out(MEM_R1out),.MEM_R2out(MEM_R2out),.MEM_WReg1(MEM_WReg1),.clk(clk),.reset(InstLoad));
	
	wire [63:0]MEM_Dout;
//sw reg

	wire [31:0]dinb_low;
	wire [31:0]dinb_high;
	wire [31:0]ctrlb;
	
	wire [7:0]addrb;
	wire [63:0]dinb;
	wire web;
	wire [31:0]doutb_high;
	wire [31:0]doutb_low;
	assign dinb = {dinb_high,dinb_low};
	assign web = ctrlb[8];
	assign addrb = ctrlb[7:0];
	DataMemory datamemory(.addra(MEM_R1out[7:0]),.dina(MEM_R2out),.wea(MEM_WMemEn),.clka(clk),.douta(MEM_Dout),
								.addrb(addrb),.dinb(dinb),.web(web),.clkb(clk),.doutb({doutb_high,doutb_low}));
	
	MEM_WBreg mem_wbreg(.MEM_WRegEn(MEM_WRegEn),.MEM_Dout(),.MEM_WReg1(MEM_WReg1),.WB_WRegEn(WB_WRegEn),.WB_Dout(),
	.WB_WReg1(WB_WReg1),.clk(clk),.reset(InstLoad));
	assign WB_Dout = MEM_Dout;

wire in_fifo_empty;
wire in_fifo_nearly_full;
assign in_rdy = !in_fifo_nearly_full;
assign out_wr = !in_fifo_empty;
assign in_fifo_read_en = !in_fifo_empty && out_rdy;

	
	fallthrough_small_fifo #(
      .WIDTH(CTRL_WIDTH+DATA_WIDTH),
      .MAX_DEPTH_BITS(2)
   ) input_fifo (
      .din           ({in_ctrl, in_data}),   // Data in
      .wr_en         (in_wr),                // Write enable
      .rd_en         (in_fifo_read_en),        // Read the next word 
      .dout          ({out_ctrl, out_data}),
      .full          (),
      .nearly_full   (in_fifo_nearly_full),
      .empty         (in_fifo_empty),
      .reset         (reset),
      .clk           (clk)
   );

	
	generic_regs
   #( 
      .UDP_REG_SRC_WIDTH   (UDP_REG_SRC_WIDTH),
      .TAG                 (`PIPE_BLOCK_ADDR),          // Tag -- eg. MODULE_TAG
      .REG_ADDR_WIDTH      (`PIPE_REG_ADDR_WIDTH),     // Width of block addresses -- eg. MODULE_REG_ADDR_WIDTH
      .NUM_COUNTERS        (0),                 // Number of counters
      .NUM_SOFTWARE_REGS   (8),                 // Number of sw regs
      .NUM_HARDWARE_REGS   (5)                  // Number of hw regs
   ) module_regs (
      .reg_req_in       (reg_req_in),
      .reg_ack_in       (reg_ack_in),
      .reg_rd_wr_L_in   (reg_rd_wr_L_in),
      .reg_addr_in      (reg_addr_in),
      .reg_data_in      (reg_data_in),
      .reg_src_in       (reg_src_in),

      .reg_req_out      (reg_req_out),
      .reg_ack_out      (reg_ack_out),
      .reg_rd_wr_L_out  (reg_rd_wr_L_out),
      .reg_addr_out     (reg_addr_out),
      .reg_data_out     (reg_data_out),
      .reg_src_out      (reg_src_out),

      // --- counters interface
      .counter_updates  (),
      .counter_decrement(),

      // --- SW regs interface
      .software_regs    ({Address,Instruction,wdata_low,wdata_high,wctrl,dinb_low,din_high,ctrlb}),

      // --- HW regs interface
      .hardware_regs    ({doutb_low,doutb_high,regfileDFF0_low,regfileDFF0_high,InstructionWatcher}),

      .clk              (clk),
      .reset            (reset)
    );
	
	initial
	begin
		InstCounter = 0;
		start = 0;
	end
	
	always @(posedge clk)
	begin
		
		if(InstLoad)
		begin
			if(start)
			begin
				if(InstCounter < 9'b000000010)
					InstCounter <= InstCounter + 1;
				else
					InstCounter <= 0;
			end
			else
				start <= 1;
		end
		else
			InstCounter <= 0;
	end

endmodule
