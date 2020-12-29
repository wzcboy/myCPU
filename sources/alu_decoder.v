`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/06 20:00:31
// Design Name: 
// Module Name: alu_decoder
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
`include "aludefines.vh"

module alu_decoder(
    input [31:0] instrD,
    output [4:0] ALUControl
);
    // declare
    wire [5:0] op;
	wire [4:0] rs,rt;
	wire [5:0] funct;

	assign op    = instrD[31:26];
	assign rs    = instrD[25:21];
	assign rt    = instrD[20:16];
	assign funct = instrD[5:0];

    reg [4:0] ALUControl_reg;

    assign ALUControl = ALUControl_reg;

    always@(instrD) begin
        case (op)
            // R type
            // only R type use [funct] , [op] = 6'b000000
            `EXE_ZERO_OP: 
                case (funct)
                    `EXE_AND:   ALUControl_reg = `ALU_AND;
                    `EXE_OR:    ALUControl_reg = `ALU_OR;   
                    `EXE_XOR:   ALUControl_reg = `ALU_XOR;
                    `EXE_NOR:   ALUControl_reg = `ALU_NOR;
                    default:    ALUControl_reg = `ALU_DEFAULT;
                endcase

            // I type
            // logic instr
            `EXE_ANDI_OP:   ALUControl_reg = `ALU_AND;
            `EXE_XORI_OP:   ALUControl_reg = `ALU_XOR;
            `EXE_LUI_OP:    ALUControl_reg = `ALU_LUI;
            `EXE_ORI_OP:    ALUControl_reg = `ALU_OR;

            default:        ALUControl_reg = `ALU_DEFAULT;
        endcase
    end
                                                                          
endmodule
