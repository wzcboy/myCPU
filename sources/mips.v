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


module mycpu_top(
    input clk,
    input resetn,
    input [5:0] int,
    // inst sram
    output         inst_sram_en,
    output [3:0]   inst_sram_wen,
    output [31:0]  inst_sram_paddr,
    output [31:0]  inst_sram_wdata,
    input  [31:0]  inst_sram_rdata,
    // data sram
    output         data_sram_en,
    output [3:0]   data_sram_wen,
    output [31:0]  data_sram_paddr,
    output [31:0]  data_sram_wdata,
    input  [31:0]  data_sram_rdata,
    //debug
    output [31:0]  debug_wb_pc,
    output [3:0]   debug_wb_rf_wen,
    output [4:0]   debug_wb_rf_wnum,
    output [31:0]  debug_wb_rf_wdata
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
    

    wire [31:0] inst_sram_addr, data_sram_addr;
    wire no_dcache;
    // assign the inst sram parameters
    assign inst_sram_en      = 1'b1;
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
    assign debug_wb_rf_wen   = {4{regWriteW}};
    assign debug_wb_rf_wnum  = writeRegW;
    assign debug_wb_rf_wdata = resultW;

    //virtual addr -> physical addr
    mmu mmu(
        .inst_vaddr(inst_sram_addr ),
        .inst_paddr(inst_sram_paddr),
        .data_vaddr(data_sram_addr ),
        .data_paddr(data_sram_paddr),
        .no_dcache (no_dcache)
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
        .rst(resetn),
        .int(int),
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
        //write back stage
        .pcW(pcW),
        .resultW(resultW),
        .writeRegW(writeRegW),
        .regWriteW(regWriteW)
    );
endmodule


