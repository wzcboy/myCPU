`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/03 20:28:12
// Design Name: 
// Module Name: i_sram_to_sram_like
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


module i_sram_to_sram_like(
    input clk, rst,
    input longest_stall,
    input flush,
    output inst_stall,
    // sram
    input          inst_sram_en,
    input  [3:0]   inst_sram_wen,
    input  [31:0]  inst_sram_addr,
    input  [31:0]  inst_sram_wdata,
    output [31:0]  inst_sram_rdata,
    
    // sram like
    output         inst_req,
    output         inst_wr,
    output [1:0]   inst_size,
    output [31:0]  inst_addr,
    output [31:0]  inst_wdata,
    input          inst_addr_ok,
    input          inst_data_ok,
    input  [31:0]  inst_rdata
    );

    reg addr_rcv;      // slave receive the req addr
    reg do_finish;     // read finish

    // data first, addr second
    always @(posedge clk) begin
        addr_rcv <= rst          ? 1'b0 :
                    inst_req & inst_addr_ok & ~inst_data_ok ? 1'b1 :    
                    (inst_data_ok) ? 1'b0 : addr_rcv;
    end

    always @(posedge clk) begin
        do_finish <= rst            ? 1'b0 :
                     inst_data_ok   ? 1'b1 :
                     ~longest_stall ? 1'b0 : do_finish;
    end

    // save rdata
    reg [31:0] inst_rdata_save;
    always @(posedge clk) begin
        inst_rdata_save <= rst ? 32'b0:
                           inst_data_ok ? inst_rdata : inst_rdata_save;
    end

    // always @(posedge clk) begin
    //     if(rst) do_finish <= 0;
    //     else if(inst_data_ok & cnt == 0) do_finish <= 1'b1;
    //     else if(longest_stall) do_finish <= do_finish;
    //     else do_finish <= 1'b0;
    // end

    // // flush count
    // reg cnt;
    // always @(posedge clk) begin
    //     if(rst) cnt <= 0;
    //     else if(flush & addr_rcv) cnt <= 1;
    //     else if(inst_data_ok) cnt <= 0;
    //     else cnt <= cnt; 
    // end


    //sram like
    assign inst_req   = inst_sram_en & ~addr_rcv & ~do_finish;
    assign inst_wr    = inst_sram_en & (| inst_sram_wen);
    assign inst_size  = 2'b10;
    assign inst_addr  = inst_sram_addr;
    assign inst_wdata = inst_sram_wdata;

    //sram
    assign inst_sram_rdata = inst_rdata_save;
    assign inst_stall = inst_sram_en & ~do_finish;
    
endmodule
