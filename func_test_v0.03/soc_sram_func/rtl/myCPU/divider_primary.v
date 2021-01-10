`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/30 21:57:35
// Design Name: 
// Module Name: divider_primary
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

module divider_primary(
    input clk, rst,
    input [5:0] ALUControl_i,
	input [31:0] opdata1_i,
	input [31:0] opdata2_i,
	input annul_i,
	
	output [63:0] result_o,
    output reg stall_div
    );

    wire div_ready;
    reg start_div, signed_div; 
    reg [31:0] opdata1_reg, opdata2_reg;
    
    // DIV FSM
    always@(*) begin
        if(rst) begin
            start_div  <= 1'b0;
            signed_div <= 1'b0;
            stall_div  <= 1'b0;
        end
        else begin
            case (ALUControl_i)
                `ALU_DIV: begin
                    if(!div_ready) begin
                        start_div  <= 1'b1;
                        signed_div <= 1'b1;
                        stall_div  <= 1'b1;
                    end else if(div_ready) begin
                        start_div  <= 1'b0;
                        signed_div <= 1'b1;
                        stall_div  <= 1'b0;
                    end else begin
                        start_div  <= 1'b0;
                        signed_div <= 1'b0;
                        stall_div  <= 1'b0;
                    end 
                end
                `ALU_DIVU: begin
                    if(!div_ready) begin
                        start_div  <= 1'b1;
                        signed_div <= 1'b0;
                        stall_div  <= 1'b1;
                    end else if(div_ready) begin
                        start_div  <= 1'b0;
                        signed_div <= 1'b0;
                        stall_div  <= 1'b0;
                    end else begin
                        start_div  <= 1'b0;
                        signed_div <= 1'b0;
                        stall_div  <= 1'b0;
                    end 
                end
                default: begin
                    start_div  <= 1'b0;
                    signed_div <= 1'b0;
                    stall_div  <= 1'b0;
                end
            endcase
        end
    end

    // when div start, opdata can't change
    always@(*) begin
        if(rst) begin
            opdata1_reg <= 0;
            opdata2_reg <= 0;
        end 
        else if((ALUControl_i == `ALU_DIV) && !start_div) begin
            opdata1_reg <= opdata1_i;
            opdata2_reg <= opdata2_i;
        end
        else if((ALUControl_i == `ALU_DIVU) && !start_div) begin
            opdata1_reg <= opdata1_i;
            opdata2_reg <= opdata2_i;
        end
        else begin
            opdata1_reg <= opdata1_reg;
            opdata2_reg <= opdata2_reg;
        end
    end

    div div(
        .clk(clk),
        .rst(rst),
        .signed_div_i(signed_div),
        .opdata1_i(opdata1_reg),
        .opdata2_i(opdata2_reg),
        .start_i(start_div),
        .annul_i(annul_i),

        .result_o(result_o),
        .ready_o(div_ready)
    );

endmodule
