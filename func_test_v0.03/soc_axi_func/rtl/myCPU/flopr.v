`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/08 01:16:48
// Design Name: 
// Module Name: flopr
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


module flopr #(parameter WIDTH = 32)(
	input wire clk, rst,
	input wire[WIDTH-1:0] d,
	output reg[WIDTH-1:0] q
	);
	always@(posedge clk, posedge rst) begin
		if(rst)begin
			q <= 0;
		end	else begin
			q <= d;
		end
	end
endmodule
