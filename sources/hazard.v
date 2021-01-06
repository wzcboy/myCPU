`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/07 15:22:20
// Design Name: 
// Module Name: hazard
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


module hazard(
    input stall_from_if,
    input stall_from_mem,
    output longest_stall,
    //Fetch stage
    output stallF, flushF,
    
    //decode stage
    input [4:0] rsD, rtD,
    input branchD, jumpD, jrD, balD,
    output forwardAD, forwardBD,
    output stallD,flushD,

    //excute stage
    input [4:0] rsE, rtE, rdE,
    input [4:0] writeRegE,
    input regWriteE,
    input memToRegE,
    input stall_divE,
    output [1:0] forwardAE, forwardBE, forwardHiloE,
    output forwardcp0E,
    output stallE, flushE,

    //mem stage
    input [4:0] writeRegM, rdM,
    input regWriteM,
    input memToRegM,
    input hilo_weM, cp0_weM,
    input flush_exceptM,
    output stallM, flushM,
    //write back stage
    input [4:0] writeRegW,
    input regWriteW,
    input hilo_weW,
    output stallW, flushW
    );
    
    //数据冒险 R型指令，前推
    assign forwardAE = ((rsE!=0) && (rsE==writeRegM) && regWriteM) ? 2'b10: 
                       ((rsE!=0) && (rsE==writeRegW) && regWriteW) ? 2'b01:
                        2'b00;
                    
    assign forwardBE = ((rtE!=0) && (rtE==writeRegM) && regWriteM) ? 2'b10: 
                       ((rtE!=0) && (rtE==writeRegW) && regWriteW) ? 2'b01:
                        2'b00;
    
    // hilo寄存器导致的数据冒险
    assign forwardHiloE = hilo_weM ? 2'b10 : (hilo_weW ? 2'b01 : 2'b00);

    // cp0 hazard forward
    assign forwardcp0E = (cp0_weM && (rdM==rdE)) ? 1'b1 : 1'b0;

    //数据冒险 load指令的，前推并且阻塞一周期
    wire lwStall;
    assign lwStall = ((rsD==rtE) || (rtD==rtE)) && memToRegE;
    
    //结构冒险 beq指令, 前推阻塞一周期并且刷新
    assign forwardAD = (rsD!=0) && (rsD==writeRegM) && regWriteM;
    assign forwardBD = (rtD!=0) && (rtD==writeRegM) && regWriteM;

    // branch and jump stall 前一条指令为ALU指令或者是load指令
    wire branchStall, jumpStall;
    assign branchStall = (branchD && regWriteE && (writeRegE==rsD || writeRegE==rtD))
                       | (branchD && memToRegM && (writeRegM==rsD || writeRegM==rtD));
    assign jumpStall = (jrD && regWriteE && (writeRegE==rsD))
                     | (jrD && memToRegM && (writeRegM==rsD));                
    
    // data hazard stall
    wire dataHz_stall;
    assign dataHz_stall = (lwStall | branchStall | jumpStall) & !flush_exceptM;
    assign longest_stall = stall_divE | stall_from_if | stall_from_mem;
    // control output
    assign stallF = (dataHz_stall | longest_stall) & ~flush_exceptM;
    assign stallD = (dataHz_stall | longest_stall) & ~flush_exceptM;
    assign stallE = longest_stall & ~flush_exceptM;
    assign stallM = longest_stall & ~flush_exceptM;
    assign stallW = longest_stall & ~flush_exceptM;

    // if there exists a stage(M or W) in stall state, you can't flushE
    assign flushF = flush_exceptM;
    assign flushD = flush_exceptM;
    assign flushE = flush_exceptM | (dataHz_stall & ~longest_stall);
    assign flushM = flush_exceptM;
    assign flushW = flush_exceptM;

endmodule

