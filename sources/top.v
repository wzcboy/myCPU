`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/09 00:10:51
// Design Name: 
// Module Name: top
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


module top(
    input clk, rst
    );

    wire [3:0] mem_wenM;
    wire [31:0] instr, pc, readData;
    wire [31:0] writeData, dataadr;

    mips mips(
        .clk(clk),
        .rst(rst),
        .readDataM(readData), 
        .instrF(instr),
        .pcF(pc),
        .ALUOutM(dataadr),
        .writeData2M(writeData),
        .mem_wenM(mem_wenM)
    );

    // instr memory
    instr_ram instr_ram (
        .clka(~clk),      // input wire clka
        .ena(1'b1),       // input wire ena
        .wea(4'b0),       // input wire [3 : 0] wea
        .addra(pc),       // input wire [31 : 0] addra
        .dina(32'b0),     // input wire [31 : 0] dina
        .douta(instr)     // output wire [31 : 0] douta
    );
    // data memory
    data_ram data_ram (
        .clka(~clk),       // input wire clka
        .ena(1'b1),        // input wire ena
        .wea(mem_wenM),    // input wire [3 : 0] wea
        .addra(dataadr),   // input wire [31 : 0] addra
        .dina(writeData),  // input wire [31 : 0] dina
        .douta(readData)   // output wire [31 : 0] douta
    );
endmodule