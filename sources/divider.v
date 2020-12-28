`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/02 19:44:40
// Design Name: 
// Module Name: divider
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


module divider(
    input clk,rst,
    output reg clk_div
);
    //100Mhz -> 1hz
//    parameter NUM_DIV = 100000000;
    parameter NUM_DIV = 80;
    reg  [25:0] cnt;
    
    always @(posedge clk,posedge rst) begin
    if(rst) begin
        cnt     <= 26'b0;
        clk_div    <= 1'b0;
    end
    else if(cnt < NUM_DIV / 2 - 1) begin
            cnt     <= cnt + 1'b1;
            clk_div    <= clk_div;
        end
        else begin
            cnt     <= 26'b0;
            clk_div    <= ~clk_div;
        end
    end
 endmodule
