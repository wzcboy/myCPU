`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/06 20:00:58
// Design Name: 
// Module Name: controller
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


module controller(
    input [5:0] opD,functD,
    output [2:0] ALUControl,
    output  jump, branch, aluSrc,memRead,memWrite,memToReg,regWrite,regDst
);
    wire  [1:0] ALUOp;

    main_decoder main_dec(
        .op(opD),
        .jump(jump), 
        .branch(branch), 
        .aluSrc(aluSrc),
        .memRead(memRead),
        .memWrite(memWrite),
        .memToReg(memToReg),
        .regWrite(regWrite),
        .regDst(regDst),
        .ALUOp(ALUOp)
    );

    alu_decoder alu_dec(
        .funct(functD),
        .ALUOp(ALUOp),
        .ALUControl(ALUControl)
    );


endmodule
