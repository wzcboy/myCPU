`timescale 1ns / 1ps

module mips_min_tb();

	reg clock_50;
	reg rst;

	wire[31:0] writedata,dataadr;
	wire memwrite;

	initial begin
		clock_50 = 1'b0;
		forever # 10 clock_50 = ~clock_50;
	end

	initial begin
		rst = 1;
		#200 rst= 0;
		#1000 $stop;
	end

	// call myCPU
	top dut(clock_50,rst,writedata,dataadr,memwrite);

endmodule

