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
    input [5:0] op, funct,
    output jump, branch, aluSrc,memRead,memWrite,memToReg,regWrite,
    output [1:0] regDst  // 00-> rt, 01-> rd, 10-> $ra
    );

    reg [8:0] sigs;
    assign {jump,branch, aluSrc,memRead,memWrite,memToReg,regWrite,regDst} = sigs;

    always@(*) begin
        case (op)
            // [op] = 6'b000000
            `EXE_ZERO_OP:
                case (funct)
                    // logic, shift, move, arithmetic
                    `EXE_AND,`EXE_OR,`EXE_XOR,`EXE_NOR, `EXE_SLL, `EXE_SRL, `EXE_SRA, `EXE_SLLV, `EXE_SRLV, `EXE_SRAV,
                    `EXE_MFHI, `EXE_MFLO,
                    `EXE_ADD,`EXE_ADDU,`EXE_SUB,`EXE_SUBU,`EXE_SLT,`EXE_SLTU: begin
                        sigs = 9'b00_00001_01;
                    end
                    `EXE_MTHI, `EXE_MTLO, `EXE_MULT, `EXE_MULTU, `EXE_DIV, `EXE_DIVU: begin
                        sigs = 9'b00_00000_00;
                    end
                    default: begin
                        sigs = 9'b00_00000_00;
                    end
                endcase
            
            // I type
            // logic, arithmetic
            `EXE_ANDI_OP, `EXE_LUI_OP, `EXE_XORI_OP, `EXE_ORI_OP,
            `EXE_ADDI_OP, `EXE_ADDIU_OP, `EXE_SLTI_OP, `EXE_SLTIU_OP: begin
                sigs = 9'b00_10001_00;
            end
            

            default: begin
                sigs = 9'b00_00000_00;
            end
        endcase
    end

endmodule
