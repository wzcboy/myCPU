`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/09 14:34:17
// Design Name: 
// Module Name: mips
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


module mips(
    input clk,rst,
    input [31:0] readDataM, instrF,
    output [31:0] pcF,
    output [31:0] ALUOutM,writeDataM,
    output memWriteM,memRead
    );
    wire [31:0] instrD;
    wire [4:0] ALUControl;
    wire jump, branch, aluSrc,memWrite,memToReg,regWrite;
    wire [1:0] regDst;
    
    wire sign_ext;
    
    main_decoder main_decoder(
        .instrD(instrD),
        .jump(jump), 
        .branch(branch), 
        .aluSrc(aluSrc),
        .memRead(memRead),
        .memWrite(memWrite),
        .memToReg(memToReg),
        .regWrite(regWrite),
        .regDst(regDst),
        .sign_ext(sign_ext)
    );

    alu_decoder alu_decoder(
        .instrD(instrD),
        .ALUControl(ALUControl)
    );

    dataPath dataPath(
        .clk(clk),
        .rst(rst),
        //fetch stage
        .instrF(instrF),
        .pcF(pcF),
        //decode stage
        .regWriteD(regWrite), 
        .memToRegD(memToReg),
        .memWriteD(memWrite),
        .aluSrcD(aluSrc),
        .regDstD(regDst),
        .branchD(branch),
        .jumpD(jump),
        .ALUControlD(ALUControl),
        .instrD(instrD),
        .sign_extD(sign_ext),
        //execute stage
    
        //mem stage
        .readDataM(readDataM),
        .ALUOutM(ALUOutM),
        .writeDataM(writeDataM),
        .memWriteM(memWriteM)
        //write back stage
    );
endmodule


