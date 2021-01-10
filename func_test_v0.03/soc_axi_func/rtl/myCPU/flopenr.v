`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/07 19:14:37
// Design Name: 
// Module Name: flopenr
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


module flopenr #(parameter WIDTH=32)(
    input clk,rst,en,
    input [WIDTH-1:0] d,
    output reg [ WIDTH-1:0] q
);
    always @(posedge clk, posedge rst) begin
        if(rst) begin
            q <= 0;
        end
        else if(en) begin
            q <= d;
        end
        else begin
            q <= q;
        end
    end
endmodule
