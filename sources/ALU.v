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
    input [4:0] f,
    output [31:0] res,
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

    // the result of the operation
    // logic instr
    wire [31:0] and_result;
    wire [31:0] or_result;
    wire [31:0] xor_result;
    wire [31:0] nor_result;
    wire [31:0] lui_result;

    // assignment
    //logic instr
    assign alu_and = !(f ^ `ALU_AND);
    assign alu_or  = !(f ^ `ALU_OR);
    assign alu_xor = !(f ^ `ALU_XOR);
    assign alu_nor = !(f ^ `ALU_NOR);
    assign alu_lui = !(f ^ `ALU_LUI);

    // calculate
    // logic instr
    assign and_result = A & B;
    assign or_result  = A | B;
    assign xor_result = A ^ B;
    assign nor_result = ~ or_result;
    assign lui_result = {B[15:0],  16'b0};


    // get the final result
    assign alu_res_general = ({32{alu_and}} & and_result) |
                             ({32{alu_or}}  & or_result)  |
                             ({32{alu_xor}} & xor_result) |
                             ({32{alu_nor}} & nor_result) |
                             ({32{alu_lui}} & lui_result);


    assign res = alu_res_general;
    
    assign overFlow = 1'b0;
    assign zero = (res==0);
endmodule
