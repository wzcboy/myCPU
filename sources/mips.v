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
    output [31:0] ALUOutM,writeData2M,
    output [3:0] mem_wenM
    );
    wire [31:0] instrD;
    wire [5:0] ALUControl;
    wire branch,jump,jal,jr,bal,aluSrc,memRead,memWrite,memToReg,regWrite,regDst;
    
    wire sign_extD;
    wire hilo_weD;
    wire isDivD;

    wire [5:0] opM;
    wire [31:0] writeDataM,finalDataM;

    controller controller(
        .instrD(instrD),
        .ALUControl(ALUControl),
        .branch(branch), 
        .jump(jump), 
        .jal(jal),
        .jr(jr),
        .bal(bal),
        .aluSrc(aluSrc),
        .memRead(memRead),
        .memWrite(memWrite),
        .memToReg(memToReg),
        .regWrite(regWrite),
        .regDst(regDst),
        .sign_ext(sign_extD),
        .hilo_we(hilo_weD),
        .isDiv(isDivD)
    );

    mem_control mem_ctrl(
        .op(opM),
        .addr(ALUOutM[1:0]),
        .writeData(writeDataM),
        .writeData2(writeData2M),
        .sel(mem_wenM),
        // read from memory
        .readData(readDataM),
        .finalData(finalDataM)
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
        .jalD(jal),
        .jrD(jr),
        .balD(bal),
        .ALUControlD(ALUControl),
        .instrD(instrD),
        .sign_extD(sign_extD),
        .hilo_weD(hilo_weD),
        .isDivD(isDivD),
        //execute stage
    
        //mem stage
        .opM(opM),
        .readDataM(finalDataM),
        .ALUOutM(ALUOutM),
        .writeDataM(writeDataM)
        //write back stage
    );
endmodule


