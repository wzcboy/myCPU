`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/03 14:47:43
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [31:0] A,
    input [31:0] B,    //默认的32位输入
    input [2:0] f,
    output reg [31:0] s,
    output overFlow,zero
);

    always@(*)
    case(f)
        3'b000: begin
            s = A & B;
        end
        3'b001: begin
            s = A | B;
        end
        3'b010: begin
            s = A + B;
        end
        3'b110: begin
            s = A - B;
        end
        3'b111: begin
            s = (A<B);
        end
        default: begin
            s = 32'b0;
        end
    endcase
    
    assign overFlow = 1'b0;
    assign zero = (s==0);
endmodule
