`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/07 10:55:25
// Design Name: 
// Module Name: mult_primary
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
`include "aludefines.vh"

module mult_primary(
    input clk, rst,
    input flush,
    input [5:0] ALUControl_i,
	input [31:0] opdata1_i,
	input [31:0] opdata2_i,
	
	output [63:0] result_o,
    output reg stall_mul
    );

    wire mult_ready;
    wire mult_ce, multu_ce;
    reg start_mul, signed_mul; 
    reg [31:0] opdata1_reg, opdata2_reg;
    wire [63:0] signed_result, unsigned_result;
    reg [3:0] cnt;

    // 8 cycles to complete mult
    assign mult_ready = !(cnt ^ 4'b1001);

    // mult FSM
    always@(*) begin
        if(rst | flush) begin
            start_mul  <= 1'b0;
            signed_mul <= 1'b0;
            stall_mul  <= 1'b0;
        end
        else begin
            case (ALUControl_i)
                `ALU_MULT: begin
                    if(!mult_ready) begin
                        start_mul  <= 1'b1;
                        signed_mul <= 1'b1;
                        stall_mul  <= 1'b1;
                    end else if(mult_ready) begin
                        start_mul  <= 1'b0;
                        signed_mul <= 1'b1;
                        stall_mul  <= 1'b0;
                    end else begin
                        start_mul  <= 1'b0;
                        signed_mul <= 1'b1;
                        stall_mul  <= 1'b0;
                    end 
                end
                `ALU_MULTU: begin
                    if(!mult_ready) begin
                        start_mul  <= 1'b1;
                        signed_mul <= 1'b0;
                        stall_mul  <= 1'b1;
                    end else if(mult_ready) begin
                        start_mul  <= 1'b0;
                        signed_mul <= 1'b0;
                        stall_mul  <= 1'b0;
                    end else begin
                        start_mul  <= 1'b0;
                        signed_mul <= 1'b0;
                        stall_mul  <= 1'b0;
                    end 
                end
                default: begin
                    start_mul  <= 1'b0;
                    signed_mul <= 1'b0; 
                    stall_mul  <= 1'b0;
                end
            endcase
        end
    end

    always@(posedge clk) begin
        if(rst | flush) begin
            cnt <= 4'b0;
        end
        else if(start_mul) begin
            cnt <= cnt + 1;
        end
        else begin
            cnt <= 4'b0;
        end
    end

    // when mult start, opdata can't change
    always@(*) begin
        if(rst | flush) begin
            opdata1_reg <= 0;
            opdata2_reg <= 0;
        end 
        else if((ALUControl_i == `ALU_MULT) && !start_mul) begin
            opdata1_reg <= opdata1_i;
            opdata2_reg <= opdata2_i;
        end
        else if((ALUControl_i == `ALU_MULTU) && !start_mul) begin
            opdata1_reg <= opdata1_i;
            opdata2_reg <= opdata2_i;
        end
        else begin
            opdata1_reg <= opdata1_reg;
            opdata2_reg <= opdata2_reg;
        end
    end

    assign mult_ce  = signed_mul  & start_mul;
    assign multu_ce = ~signed_mul & start_mul;

    signed_mult signed_mult (
        .CLK(clk),                  // input wire CLK
        .A(opdata1_reg),                 // input wire [31 : 0] A
        .B(opdata2_reg),                 // input wire [31 : 0] B
        .CE(mult_ce),        // input wire CE
        .SCLR(flush),
        .P(signed_result)     // output wire [63 : 0] P
    );

    unsigned_mult unsigned_mult (
        .CLK(clk),                  // input wire CLK
        .A(opdata1_reg),                 // input wire [31 : 0] A
        .B(opdata2_reg),                 // input wire [31 : 0] B
        .CE(multu_ce),      // input wire CE
        .SCLR(flush),
        .P(unsigned_result)   // output wire [63 : 0] P
    );

    assign result_o = signed_mul   ? signed_result :
                      ~signed_mul  ? unsigned_result : 64'b0;

endmodule
