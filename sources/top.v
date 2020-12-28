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
    input clk, rst,
    output [31:0] writeData,dataadr,
    output memWrite
    );
    wire data_ram_ena;
    wire [31:0] instr, pc, readData;

    mips mips(
        .clk(clk),
        .rst(rst),
        .readDataM(readData), 
        .instrF(instr),
        .pcF(pc),
        .ALUOutM(dataadr),
        .writeDataM(writeData),
        .memWriteM(memWrite),
        .memRead(data_ram_ena)
    );

    //指令内存
    instr_ram instr_ram (
        .clka(~clk),    // input wire clka
        .ena(1'b1),      // input wire ena
        .wea(4'b0),      // input wire [3 : 0] wea
        .addra(pc),  // input wire [31 : 0] addra
        .dina(32'b0),    // input wire [31 : 0] dina
        .douta(instr)  // output wire [31 : 0] douta
    );
    //数据内存
    data_ram data_ram (
        .clka(~clk),    // input wire clka
        .ena(1'b1),      // input wire ena
        .wea({4{memWrite}}),      // input wire [3 : 0] wea
        .addra(dataadr),  // input wire [31 : 0] addra
        .dina(writeData),    // input wire [31 : 0] dina
        .douta(readData)  // output wire [31 : 0] douta
    );
endmodule