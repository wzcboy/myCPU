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


module main_decoder(
    input [5:0] op,
    output jump, branch, aluSrc,memRead,memWrite,memToReg,regWrite,regDst,
    output [1:0] ALUOp
    );

    reg [1:0] ALUOp_reg;
    reg [7:0] sigs;
    
    assign ALUOp = ALUOp_reg;
    assign {jump,branch, aluSrc,memRead,memWrite,memToReg,regWrite,regDst} = sigs;

    always@(op) begin
        casex(op)
            6'b000000: begin              //RÐÍ
                ALUOp_reg = 2'b10;
                sigs = 8'b0000_0011;
            end
            6'b100011: begin              //lw
                ALUOp_reg = 2'b00;
                sigs = 8'b0011_0110;
            end
            6'b101011: begin              //sw
                ALUOp_reg = 2'b00;
                sigs = 8'b0010_1?0?;
            end
            6'b000100: begin              //beq
                ALUOp_reg = 2'b01;
                sigs = 8'b0100_0?0?;
            end
            6'b001000: begin              //addi
                ALUOp_reg = 2'b00;
                sigs = 8'b0010_0010;
            end
            6'b000010: begin              //jump
                ALUOp_reg = 2'b??;
                sigs = 8'b10??_0000;
            end
            default: begin
                ALUOp_reg = 2'b00;
                sigs = 8'b0000_0000;
            end
        endcase
    end
endmodule
