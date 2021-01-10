`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/07 15:31:49
// Design Name: 
// Module Name: mux3to1
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


module mux3to1 #(parameter WIDTH=32)(
    input [WIDTH-1:0] a, b, c,
    input [1:0] s,
    output [WIDTH-1:0] y
    );
    assign y = (s==2'b00) ? a :
                    (s==2'b01) ? b :
                    (s==2'b10) ? c : a;
endmodule
