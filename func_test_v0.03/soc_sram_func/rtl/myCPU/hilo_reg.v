`timescale 1ns / 1ps

module hilo_reg(
	input wire clk,rst,we,
	input wire[31:0] hi,lo,
	output reg[31:0] hi_o,lo_o
    );
	// notice: the clk is negedge
	always @(negedge clk) begin
		if(rst) begin
			hi_o <= 0;
			lo_o <= 0;
		end else if (we) begin
			hi_o <= hi;
			lo_o <= lo;
		end
        else begin
            hi_o <= hi_o;
            lo_o <= lo_o;
        end
	end
endmodule