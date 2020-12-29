`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/06 20:00:00
// Design Name: 
// Module Name: main_decoder
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

module main_decoder(
    input [31:0] instrD,
    output jump, branch, aluSrc,memRead,memWrite,memToReg,regWrite,
    output [1:0] regDst,  // 00-> rt, 01-> rd, 10-> $ra

    output sign_ext
    );
    // declare
    wire [5:0] op;
	wire [4:0] rs,rt;
	wire [5:0] funct;

	assign op    = instrD[31:26];
	assign rs    = instrD[25:21];
	assign rt    = instrD[20:16];
	assign funct = instrD[5:0];

    reg [8:0] sigs;
    
    assign {jump,branch, aluSrc,memRead,memWrite,memToReg,regWrite,regDst} = sigs;

    // get the control siganl
    assign sign_ext = |(op[5:2] ^ 4'b0011);		// andi, xori, lui, ori->zero_extend, other->sign_extend

    always@(instrD) begin
        case (op)
            // [op] = 6'b000000
            `EXE_ZERO_OP:
                case (funct)
                    `EXE_AND,`EXE_OR,`EXE_XOR,`EXE_NOR, `EXE_SLL, `EXE_SRL, `EXE_SRA, `EXE_SLLV, `EXE_SRLV, `EXE_SRAV: begin
                        sigs = 9'b00_00001_01;
                    end
                    default: begin
                        sigs = 9'b00_00000_00;
                    end
                endcase
            
            // I type
            // logic instr
            `EXE_ANDI_OP, `EXE_LUI_OP, `EXE_XORI_OP, `EXE_ORI_OP: begin
                sigs = 9'b00_10001_00;
            end
            

            default: begin
                sigs = 9'b00_00000_00;
            end
        endcase
    end

endmodule
