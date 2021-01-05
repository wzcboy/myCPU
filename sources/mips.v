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
    input clk,
    input rst,
    input [5:0] int,

    //inst
    output wire inst_req            ,
    output wire inst_wr             ,
    output wire [1:0] inst_size     ,
    output wire [31:0] inst_addr    ,
    output wire [31:0] inst_wdata   ,
    input  wire inst_addr_ok        ,
    input  wire inst_data_ok        ,
    input  wire [31:0] inst_rdata   ,

    //data
    output wire data_req            ,
    output wire data_wr             ,
    output wire [1:0] data_size     ,
    output wire [31:0] data_addr    ,
    output wire [31:0] data_wdata   ,
    input  wire data_addr_ok        ,
    input  wire data_data_ok        ,
    input  wire [31:0] data_rdata   ,

    //debug
    output wire [31:0]  debug_wb_pc     ,      
    output wire [3:0]   debug_wb_rf_wen ,
    output wire [4:0]   debug_wb_rf_wnum, 
    output wire [31:0]  debug_wb_rf_wdata
    );
    
    // fetch stage
    wire [31:0] instrF, pcF;

    // decode stage
    wire [31:0] instrD;
    wire [5:0] ALUControl;
    wire branch,jump,jal,jr,bal,aluSrc,memRead,memWrite,memToReg,regWrite,regDst;
    wire sign_extD;
    wire hilo_weD;
    wire isDivD;
    wire invalidD;
    wire cp0_weD;
    // memory stage
    wire [31:0] pcM,bad_addrM;
    wire [5:0] opM;
    wire [31:0] writeDataM,readDataM,finalDataM;
    wire [31:0] ALUOutM,writeData2M;
    wire [3:0] mem_wenM;
    wire mem_enM;
    wire adelM, adesM;

    // WB stage
    wire [31:0] pcW, resultW;
    wire [4:0] writeRegW;
    wire regWriteW;
    wire stallW;
    
    // stall signal
    wire longest_stall, flush_exceptM;
    wire stall_from_mem;
    wire inst_stall, data_stall;
    assign stall_from_mem = (inst_stall | data_stall) ? 1'b1 : 1'b0;
    
    // declare inst sram parameters
    wire inst_sram_en;
    wire [3:0]  inst_sram_wen;
    wire [31:0] inst_sram_addr;
    wire [31:0] inst_sram_wdata;
    wire [31:0] inst_sram_rdata;
    
    // declare data sram parameters
    wire data_sram_en;
    wire [3:0]  data_sram_wen;
    wire [31:0] data_sram_addr;
    wire [31:0] data_sram_wdata;
    wire [31:0] data_sram_rdata;

    // assign the inst sram parameters
    assign inst_sram_en      = ~flush_exceptM;
    assign inst_sram_wen     = 4'b0;
    assign inst_sram_addr    = pcF;
    assign inst_sram_wdata   = 32'b0;
    assign instrF            = inst_sram_rdata;

    // assign the data sram parameters
    assign data_sram_en      = mem_enM;
    assign data_sram_wen     = mem_wenM;
    assign data_sram_addr    = ALUOutM;
    assign data_sram_wdata   = writeData2M;
    assign readDataM         = data_sram_rdata;

    // debug
    assign debug_wb_pc       = pcW;
    assign debug_wb_rf_wen   = {4{regWriteW & ~longest_stall}};
    assign debug_wb_rf_wnum  = writeRegW;
    assign debug_wb_rf_wdata = resultW;

    //inst sram to sram-like
    i_sram_to_sram_like i_sram_to_sram_like(
        .clk(clk), .rst(rst),
        .longest_stall(longest_stall),
        .flush(flush_exceptM),
        .inst_stall(inst_stall),
        //sram
        .inst_sram_en(inst_sram_en),
        .inst_sram_addr(inst_sram_addr),
        .inst_sram_rdata(inst_sram_rdata),
        .inst_sram_wen(inst_sram_wen),
        .inst_sram_wdata(inst_sram_wdata),
        //sram like
        .inst_req(inst_req),    
        .inst_wr(inst_wr),
        .inst_size(inst_size),
        .inst_addr(inst_addr),   
        .inst_wdata(inst_wdata),
        .inst_addr_ok(inst_addr_ok),
        .inst_data_ok(inst_data_ok),
        .inst_rdata(inst_rdata)
    );

     //data sram to sram-like
    d_sram_to_sram_like d_sram_to_sram_like(
        .clk(clk), .rst(rst),
        .longest_stall(longest_stall),
        .data_stall(data_stall),
        //sram
        .data_sram_en(data_sram_en),
        .data_sram_addr(data_sram_addr),
        .data_sram_rdata(data_sram_rdata),
        .data_sram_wen(data_sram_wen),
        .data_sram_wdata(data_sram_wdata),
        //sram like
        .data_req(data_req),    
        .data_wr(data_wr),
        .data_size(data_size),
        .data_addr(data_addr),   
        .data_wdata(data_wdata),
        .data_addr_ok(data_addr_ok),
        .data_data_ok(data_data_ok),
        .data_rdata(data_rdata)
    );



    // my controller
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
        .isDiv(isDivD),
        .invalid(invalidD),
        .cp0_we(cp0_weD)
    );

    mem_control mem_ctrl(
        .op(opM),
        .addr(ALUOutM),
        .writeData(writeDataM),
        .writeData2(writeData2M),
        .sel(mem_wenM),
        // read from memory
        .readData(readDataM),
        .finalData(finalDataM),
        // exception
        .pc(pcM),
        .bad_addr(bad_addrM),
        .adel(adelM), 
        .ades(adesM)
    );

    dataPath dataPath(
        .clk(clk),
        .rst(rst),
        .int(int),
        .longest_stall(longest_stall),
        .stall_from_if(inst_stall),
        .stall_from_mem(data_stall),
        //fetch stage
        .instrF(instrF),
        .pcF(pcF),
        //decode stage
        .regWriteD(regWrite), 
        .memToRegD(memToReg),
        .memReadD(memRead),
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
        .invalidD(invalidD),
        .cp0_weD(cp0_weD),
        //execute stage
    
        //mem stage
        .pcM(pcM),
        .opM(opM),
        .readDataM(finalDataM),
        .ALUOutM(ALUOutM),
        .writeDataM(writeDataM),
        .mem_enM(mem_enM),
        .bad_addrM(bad_addrM),
        .adelM(adelM),
        .adesM(adesM),
        .flush_exceptM(flush_exceptM),
        //write back stage
        .pcW(pcW),
        .resultW(resultW),
        .writeRegW(writeRegW),
        .regWriteW(regWriteW),
        .stallW(stallW)
    );
endmodule