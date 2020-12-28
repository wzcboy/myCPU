`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/09 00:01:26
// Design Name: 
// Module Name: regfile
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


module regfile(
    input clk,
    input we,
    input [4:0] ra1,ra2,wa,
    input [31:0] din,
    output [31:0] dout1,dout2
    );

    reg [31:0] rf [31:0];

    always@(posedge clk) begin
        if(we) begin
            rf[wa] = din;
        end
    end

    //只要读到0号寄存器都为0，修改也无效
    assign dout1 = (ra1!=0) ? rf[ra1] : 0; 
    assign dout2 = (ra2!=0) ? rf[ra2] : 0;
endmodule
