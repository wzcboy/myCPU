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
    input [5:0] op, funct,
    output [5:0] ALUControl
);

    reg [5:0] ALUControl_reg;
    assign ALUControl = ALUControl_reg;

    always@(*) begin
        case (op)
            // R type
            // only R type use [funct] , [op] = 6'b000000
            `EXE_ZERO_OP: 
                case (funct)
                    // logic
                    `EXE_AND:   ALUControl_reg = `ALU_AND;
                    `EXE_OR:    ALUControl_reg = `ALU_OR;   
                    `EXE_XOR:   ALUControl_reg = `ALU_XOR;
                    `EXE_NOR:   ALUControl_reg = `ALU_NOR;
                    // shift
                    `EXE_SLL:   ALUControl_reg = `ALU_SLL;
                    `EXE_SRL:   ALUControl_reg = `ALU_SRL;
                    `EXE_SRA:   ALUControl_reg = `ALU_SRA;
                    `EXE_SLLV:  ALUControl_reg = `ALU_SLLV;
                    `EXE_SRLV:  ALUControl_reg = `ALU_SRLV;
                    `EXE_SRAV:  ALUControl_reg = `ALU_SRAV;
                    // move
                    `EXE_MFHI:  ALUControl_reg = `ALU_MFHI;
                    `EXE_MFLO:  ALUControl_reg = `ALU_MFLO;
                    `EXE_MTHI:  ALUControl_reg = `ALU_MTHI;
                    `EXE_MTLO:  ALUControl_reg = `ALU_MTLO;
                    // arithmetic
                    `EXE_ADD:   ALUControl_reg = `ALU_ADD;
                    `EXE_ADDU:  ALUControl_reg = `ALU_ADDU;
                    `EXE_SUB:   ALUControl_reg = `ALU_SUB;
                    `EXE_SUBU:  ALUControl_reg = `ALU_SUBU;
                    `EXE_SLT:   ALUControl_reg = `ALU_SLT;
                    `EXE_SLTU:  ALUControl_reg = `ALU_SLTU;
                    `EXE_MULT:  ALUControl_reg = `ALU_MULT;
                    `EXE_MULTU: ALUControl_reg = `ALU_MULTU;
                    `EXE_DIV:   ALUControl_reg = `ALU_DIV;
                    `EXE_DIVU:  ALUControl_reg = `ALU_DIVU;

                    default:    ALUControl_reg = `ALU_DEFAULT;
                endcase

            // I type
            // logic instr
            `EXE_ANDI_OP:   ALUControl_reg = `ALU_AND;
            `EXE_XORI_OP:   ALUControl_reg = `ALU_XOR;
            `EXE_LUI_OP:    ALUControl_reg = `ALU_LUI;
            `EXE_ORI_OP:    ALUControl_reg = `ALU_OR;
            // arithmetic instr
            `EXE_ADDI_OP: 	ALUControl_reg <= `ALU_ADD;
			`EXE_ADDIU_OP:  ALUControl_reg <= `ALU_ADDU;
			`EXE_SLTI_OP: 	ALUControl_reg <= `ALU_SLT;
			`EXE_SLTIU_OP:  ALUControl_reg <= `ALU_SLTU;
            // load and store instr
            `EXE_LB_OP, `EXE_LBU_OP, `EXE_LH_OP, `EXE_LHU_OP, `EXE_LW_OP, `EXE_SB_OP, `EXE_SH_OP, `EXE_SW_OP: begin
                            ALUControl_reg <= `ALU_ADDU;
            end     
            default:        ALUControl_reg = `ALU_DEFAULT;
        endcase
    end
                                                                          
endmodule
