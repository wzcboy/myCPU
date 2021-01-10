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
    input [31:0] instrD,

    output [5:0] ALUControl,
    output branch,jump,jal,jr,bal,aluSrc,memRead,memWrite,memToReg,regWrite,regDst,
    output sign_ext,
    output hilo_we,   // hilo write enable
    output isDiv, isMul,
    output invalid,
    output cp0_we
);
    // declare
    wire [5:0] op;
	wire [4:0] rs,rt;
	wire [5:0] funct;
    
    assign op    = instrD[31:26];
	assign rs    = instrD[25:21];
	assign rt    = instrD[20:16];
	assign funct = instrD[5:0];

    // get the control siganl
    assign sign_ext = |(op[5:2] ^ 4'b0011);		                    // andi, xori, lui, ori->zero_extend, other->sign_extend
    assign hilo_we = ~(| ( op ^ `EXE_ZERO_OP )) 
					   & ( ~(|(funct[5:2] ^ 4'b0110)) 			    // div divu mult multu  	
					   | ( ~(|(funct[5:2] ^ 4'b0100)) & funct[0])); //mthi mtlo

    assign isDiv = ~(|op) & ~(|(funct[5:1] ^ 5'b01101));	//opcode==0, funct==01101x
    assign isMul = ~(|op) & ~(|(funct[5:1] ^ 5'b01100));	//opcode==0, funct==01100x

    assign cp0_we = ~(|( op ^ `EXE_PRI_OP)) & ~(|(rs ^ `EXE_MTC0));   // mtc0

    main_decoder main_dec(
        .instrD(instrD),
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
        .invalid(invalid)
    );

    alu_decoder alu_dec(
        .op(op),
        .funct(funct),
        .rs(rs),
        .ALUControl(ALUControl)
    );


endmodule