`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/03 14:47:43
// Design Name: 
// Module Name: ALU
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
`include "aludefines.vh"

module ALU(
    input [31:0] A,
    input [31:0] B,
    input [4:0] sa,     // [shift] in instr
    input [5:0] f,
    input [63:0] hilo,
    output [63:0] res,
    output overFlow,zero
);
    // result signal
    wire [31:0] alu_res_general;   // The result of not multiplication or division

    // the type of operation
    // logic instr
    wire alu_and;
    wire alu_or;
    wire alu_xor;
    wire alu_nor;
    wire alu_lui;
    // shift instr
    wire alu_sll;
    wire alu_sllv;
    wire alu_srl;
    wire alu_sra;
    wire alu_srlv;
    wire alu_srav;
    // move instr
    wire alu_mfhi;
    wire alu_mflo;
    wire alu_mthi;
    wire alu_mtlo;

    // the result of the operation
    // logic instr
    wire [31:0] and_result;
    wire [31:0] or_result;
    wire [31:0] xor_result;
    wire [31:0] nor_result;
    wire [31:0] lui_result;
    // shift instr
    wire [31:0] sll_result;
    wire [31:0] sllv_result;
    wire [31:0] srl_result;
    wire [31:0] sra_result;
    wire [31:0] srlv_result;
    wire [31:0] srav_result;
    // move instr
    wire [63:0] mfhi_result;
    wire [63:0] mflo_result;
    wire [63:0] mthi_result;
    wire [63:0] mtlo_result;

    // assignment
    //logic instr
    assign alu_and  = !(f ^ `ALU_AND);
    assign alu_or   = !(f ^ `ALU_OR);
    assign alu_xor  = !(f ^ `ALU_XOR);
    assign alu_nor  = !(f ^ `ALU_NOR);
    assign alu_lui  = !(f ^ `ALU_LUI);
    // shift instr
    assign alu_sll  = !(f ^ `ALU_SLL);
    assign alu_sllv = !(f ^ `ALU_SLLV);
    assign alu_srl  = !(f ^ `ALU_SRL);
    assign alu_sra  = !(f ^ `ALU_SRA);
    assign alu_srlv = !(f ^ `ALU_SRLV);
    assign alu_srav = !(f ^ `ALU_SRAV);
    // move instr
    assign alu_mfhi = !(f ^ `ALU_MFHI);
    assign alu_mflo = !(f ^ `ALU_MFLO);
    assign alu_mthi = !(f ^ `ALU_MTHI);
    assign alu_mtlo = !(f ^ `ALU_MTLO);


    // calculate
    // logic instr
    assign and_result  = A & B;
    assign or_result   = A | B;
    assign xor_result  = A ^ B;
    assign nor_result  = ~ or_result;
    assign lui_result  = {B[15:0], 16'b0};
    // shift instr
    wire [4:0] s;
    wire [63:0] sr64_result;
    assign s = (alu_sll | alu_srl | alu_sra) ? sa : A[4:0];
    assign sr64_result = {{32{B[31]}},B[31:0]} >> s; // sra srav
    assign sll_result  = B << s;
    assign sllv_result = B << s;
    assign srl_result  = B >> s;
    assign srlv_result = B >> s;
    assign sra_result  = sr64_result[31:0];
    assign srav_result = sr64_result[31:0];
    // move instr
    assign mfhi_result = {32'b0, hilo[63:32]};
    assign mflo_result = {32'b0, hilo[31:0]};
    assign mthi_result = {A, hilo[31:0]};
    assign mtlo_result = {hilo[63:32], A};

    // get the final result
    assign alu_res_general = ({32{alu_and}}  & and_result)  |
                             ({32{alu_or}}   & or_result)   |
                             ({32{alu_xor}}  & xor_result)  |
                             ({32{alu_nor}}  & nor_result)  |
                             ({32{alu_lui}}  & lui_result)  |
                             ({32{alu_sll}}  & sll_result)  |
                             ({32{alu_sllv}} & sllv_result) |
                             ({32{alu_srl}}  & srl_result)  |
                             ({32{alu_sra}}  & sra_result)  |
                             ({32{alu_srlv}} & srlv_result) |
                             ({32{alu_srav}} & srav_result);


    assign res = ({64{alu_mfhi}} & mfhi_result)
               | ({64{alu_mflo}} & mflo_result)
               | ({64{alu_mthi}} & mthi_result)
               | ({64{alu_mtlo}} & mtlo_result)
               | ({64{!alu_mfhi & ! alu_mflo & !alu_mthi & !alu_mtlo}} & {32'b0, alu_res_general});
    
    assign overFlow = 1'b0;
    assign zero = (res==0);
endmodule
