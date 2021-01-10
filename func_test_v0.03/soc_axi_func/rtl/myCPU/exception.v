`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/02 15:17:39
// Design Name: 
// Module Name: exception
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
`include "defines.vh"

module exception(
    input rst,
    // {pcError, syscall, break, eret, invalid, overflow, .., ..}
    input [7:0] except,
    input adel, ades,
    input int_forward,
    input [31:0] cp0_status, cp0_cause, epc_o,
    output reg [31:0] excepttype, newpcM
    );

    always@(*) begin
        if(rst) begin
            excepttype <= 32'b0;
        end else begin
            if(((cp0_cause[15:8] & cp0_status[15:8]) != 8'h00) && !cp0_status[1] && cp0_status[0]) begin
                excepttype <= `EXC_TYPE_INT;
                newpcM <=  32'hbfc00380;
            end else if(int_forward) begin
                excepttype <= `EXC_TYPE_INT_FORWARD;
                newpcM <=  32'hbfc00380;
            end else if (except[7] | adel) begin
                excepttype <= `EXC_TYPE_ADEL;
                newpcM <=  32'hbfc00380;
            end else if (ades) begin
                excepttype <= `EXC_TYPE_ADES;
                newpcM <=  32'hbfc00380;
            end else if (except[6]) begin
                excepttype <= `EXC_TYPE_SYS;
                newpcM <=  32'hbfc00380;
            end else if (except[5]) begin
                excepttype <= `EXC_TYPE_BP;
                newpcM <=  32'hbfc00380;
            end else if (except[4]) begin
                excepttype <= `EXC_TYPE_ERET;
                newpcM <= epc_o;
            end else if (except[3]) begin
                excepttype <= `EXC_TYPE_RI;
                newpcM <=  32'hbfc00380;
            end else if (except[2]) begin
                excepttype <= `EXC_TYPE_OV;
                newpcM <=  32'hbfc00380;
            end else begin
                excepttype <= `EXC_TYPE_NOEXC;
                newpcM <= newpcM;
            end
        end
    end
endmodule
