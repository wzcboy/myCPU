`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/03 20:28:12
// Design Name: 
// Module Name: d_sram_to_sram_like
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


module d_sram_to_sram_like(
    input clk, rst,
    input longest_stall,
    output data_stall,
    // sram
    input          data_sram_en,
    input  [3:0]   data_sram_wen,
    input  [31:0]  data_sram_addr,
    input  [31:0]  data_sram_wdata,
    output [31:0]  data_sram_rdata,
    
    // sram like
    output         data_req,
    output         data_wr,
    output [1:0]   data_size,
    output [31:0]  data_addr,
    output [31:0]  data_wdata,
    input          data_addr_ok,
    input          data_data_ok,
    input  [31:0]  data_rdata
    );

    reg addr_rcv;      // slave receive the req addr
    reg do_finish;     // read finish

    // data first, addr second
    always @(posedge clk) begin
        addr_rcv <= rst          ? 1'b0 :
                    data_req & data_addr_ok & ~data_data_ok ? 1'b1 :    
                    data_data_ok ? 1'b0 : addr_rcv;
    end

    always @(posedge clk) begin
        do_finish <= rst          ? 1'b0 :
                     data_data_ok ? 1'b1 :
                     ~longest_stall ? 1'b0 : do_finish;
    end

    // save rdata
    reg [31:0] data_rdata_save;
    always @(posedge clk) begin
        data_rdata_save <= rst ? 32'b0:
                           data_data_ok ? data_rdata : data_rdata_save;
    end

    //sram like
    assign data_req   = data_sram_en & ~addr_rcv & ~do_finish;
    assign data_wr    = data_sram_en & (|data_sram_wen);
    assign data_size = (data_sram_wen==4'b0001 || data_sram_wen==4'b0010 || data_sram_wen==4'b0100 || data_sram_wen==4'b1000) ? 2'b00:
                       (data_sram_wen==4'b0011 || data_sram_wen==4'b1100 ) ? 2'b01 : 2'b10;
    assign data_addr  = data_sram_addr;
    assign data_wdata = data_sram_wdata;

    //sram
    assign data_sram_rdata = data_rdata_save;
    assign data_stall = data_sram_en & ~do_finish;
    
endmodule
