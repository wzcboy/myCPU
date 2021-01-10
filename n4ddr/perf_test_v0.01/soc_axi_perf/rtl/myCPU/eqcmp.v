`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/07 18:58:10
// Design Name: 
// Module Name: eqcmp
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "defines.vh"

module eqcmp(
	input wire [31:0] a,b,
	input wire [5:0] op,
	input wire [4:0] rt,
	output wire y
    );

	assign y = ( op == `EXE_BEQ_OP)  ? (a == b):
			   ( op == `EXE_BNE_OP)  ? (a != b):
			   ( op == `EXE_BGTZ_OP) ? (!a[31] & (a != 32'b0)):
			   ( op == `EXE_BLEZ_OP) ? ( a[31] | (a == 32'b0)):
			   ((op == `EXE_REGIMM_OP) && ((rt == `EXE_BGEZ) || (rt == `EXE_BGEZAL))) ? (!a[31] | (a == 32'b0)):
			   ((op == `EXE_REGIMM_OP) && ((rt == `EXE_BLTZ) || (rt == `EXE_BLTZAL))) ? ( a[31] & (a != 32'b0)): 0;

endmodule

