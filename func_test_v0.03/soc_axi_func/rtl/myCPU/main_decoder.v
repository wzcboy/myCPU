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
    output branch,jump,jal,jr,bal,aluSrc,memRead,memWrite,memToReg,regWrite,regDst,  // 0-> rt, 1-> rd
    output reg invalid
    );

    reg [10:0] sigs;
    assign {branch, jump, jal, jr, bal, aluSrc, memRead, memWrite, memToReg, regWrite, regDst} = sigs;

    wire [5:0] op;
	wire [4:0] rs,rt;
	wire [5:0] funct;
    assign op    = instrD[31:26];
	assign rs    = instrD[25:21];
	assign rt    = instrD[20:16];
	assign funct = instrD[5:0];

    always@(*) begin
        invalid = 1'b0;
        case (op)
            // [op] = 6'b000000
            `EXE_ZERO_OP:
                case (funct)
                    // logic, shift, move, arithmetic
                    `EXE_AND,`EXE_OR,`EXE_XOR,`EXE_NOR, `EXE_SLL, `EXE_SRL, `EXE_SRA, `EXE_SLLV, `EXE_SRLV, `EXE_SRAV,
                    `EXE_MFHI, `EXE_MFLO,
                    `EXE_ADD,`EXE_ADDU,`EXE_SUB,`EXE_SUBU,`EXE_SLT,`EXE_SLTU: begin
                        sigs <= 11'b0000_0000_011;
                    end
                    `EXE_MTHI, `EXE_MTLO, `EXE_MULT, `EXE_MULTU, `EXE_DIV, `EXE_DIVU,
                    `EXE_BREAK, `EXE_SYSCALL: begin
                        sigs <= 11'b0000_0000_000;
                    end
                    `EXE_JR: begin
                        sigs <= 11'b0101_0000_000;
                    end
                    `EXE_JALR: begin
                        sigs <= 11'b0001_0000_011;
                    end
                    default: begin
                        sigs <= 11'b0000_0000_000;
                        invalid <= 1'b1;
                    end
                endcase
            
            // I type
            // logic, arithmetic
            `EXE_ANDI_OP, `EXE_LUI_OP, `EXE_XORI_OP, `EXE_ORI_OP,
            `EXE_ADDI_OP, `EXE_ADDIU_OP, `EXE_SLTI_OP, `EXE_SLTIU_OP: begin
                sigs <= 11'b0000_0100_010;
            end
            // jump and branch
            `EXE_J_OP: begin
                sigs <= 11'b0100_0000_000;
            end
            `EXE_JAL_OP: begin
                sigs <= 11'b0010_0000_010;
            end
            `EXE_BEQ_OP, `EXE_BNE_OP, `EXE_BGTZ_OP, `EXE_BLEZ_OP: begin
                sigs <= 11'b1000_0000_000;
            end
            `EXE_REGIMM_OP: begin
                case (rt)
                    `EXE_BLTZ, `EXE_BGEZ:     sigs <= 11'b1000_0000_000; 
                    `EXE_BLTZAL, `EXE_BGEZAL: sigs <= 11'b1000_1000_010;
                    default: begin
                        sigs <= 11'b0000_0000_000;
                        invalid <= 1'b1;
                    end                 
                endcase
            end
            // load and store
            `EXE_LB_OP, `EXE_LBU_OP, `EXE_LH_OP, `EXE_LHU_OP, `EXE_LW_OP: begin
                sigs <= 11'b0000_0110_110;
            end
            `EXE_SB_OP, `EXE_SH_OP, `EXE_SW_OP: begin
                sigs <= 11'b0000_0101_000;
            end
            // privileged 
            `EXE_PRI_OP: begin
                case (rs)
                    `EXE_MTC0: sigs <= 11'b0000_0000_000;
                    `EXE_MFC0: sigs <= 11'b0000_0000_010; 
                    default: begin
                        sigs <= 11'b0000_0000_000;
                        invalid <= |(instrD ^ `EXE_ERET);
                    end
                endcase
            end
            `EXE_ABS_OP: begin
                sigs <= 11'b0000_0000_011;

            end
            default: begin
                sigs <= 11'b0000_0000_000;
                invalid <= 1'b1;
            end
        endcase
    end

endmodule
