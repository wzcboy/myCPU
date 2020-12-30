`timescale 1ns / 1ps

module dataPath(
    input clk,rst,
    //fetch stage
    input [31:0] instrF,
    output [31:0] pcF,
    //decode stage
    input regWriteD, memToRegD,memWriteD,aluSrcD,branchD,jumpD,
    input [1:0] regDstD,
    input [5:0] ALUControlD,
    input sign_extD,
    input hilo_weD,
    input isDivD,
    output [31:0] instrD,
    //execute stage
    
    //mem stage
    input [31:0] readDataM,
    output [31:0] ALUOutM,writeDataM,
    output memWriteM
    //write back stage

    );

    //fetch stage
    wire stallF;
    //FD
    wire [31:0] pc_next_FD, pc_nextbrFD, pc_plus4F,pc_branchD;
    //decode stage
    wire [31:0] pc_plus4D;
    wire forwardAD, forwardBD,euqalD,pcSrcD;
    wire [4:0] rsD,rtD,rdD,saD;
    wire stallD, flushD;
    wire [31:0] signImmD,signImmD_sl2D;
    wire [31:0] srcaD,srca2D,srcbD,srcb2D;
    //execute stage
    wire [1:0] forwardAE,forwardBE, forwardHiloE;
    wire [4:0] rsE,rtE,rdE,saE;
    wire stallE, flushE;
    wire [4:0] writeRegE;
    wire [31:0] signImmE;
    wire [31:0] srcaE,srca2E,srcbE,srcb2E,srcb3E;
    wire memToRegE,memWriteE,aluSrcE,regWriteE;
    wire [1:0] regDstE;
    wire [5:0] ALUControlE;
    wire [63:0] ALUOutE;
    wire [63:0] hilo_for_aluE;
    wire hilo_weE;
    wire [63:0] alu_resultE, div_resultE;
    wire stall_divE, isDivE;
    //mem stage
    wire [4:0] writeRegM;
    wire memToRegM,regWriteM;
    wire hilo_weM;
    wire [63:0] hilo_iM;
    //write back stage
    wire [4:0] writeRegW;
    wire [31:0] ALUOutW,readDataW,resultW;
    wire memToRegW,regWriteW;
    wire hilo_weW;
    wire [63:0] hilo_iW, hilo_oW;

    wire zero,overFlow;               //临时信号，用处不大

    assign pcSrcD = branchD & euqalD;  //是否跳转信号

    //冒险控制
    hazard h(
     //fetch stage
    .stallF(stallF),
    //decode stage
    .rsD(rsD), 
    .rtD(rtD),
    .branchD(branchD),
    .forwardAD(forwardAD), 
    .forwardBD(forwardBD),
    .stallD(stallD),
    //excute stage
    .rsE(rsE), 
    .rtE(rtE),
    .writeRegE(writeRegE),
    .regWriteE(regWriteE),
    .memToRegE(memToRegE),
    .forwardAE(forwardAE), 
    .forwardBE(forwardBE),
    .flushE(flushE),
    .forwardHiloE(forwardHiloE),
    .stall_divE(stall_divE),
    .stallE(stallE),
    //mem stage
    .writeRegM(writeRegM),
    .regWriteM(regWriteM),
    .memToRegM(memToRegM),
    .hilo_weM(hilo_weM),
    //write back stage
    .writeRegW(writeRegW),
    .regWriteW(regWriteW),
    .hilo_weW(hilo_weW)
    );

    //mux for beq
    // pcSrc=1, choose pc_branch
    mux2to1 #(32) mux_pc_beq(
        .a(pc_branchD),
        .b(pc_plus4F),
        .s(pcSrcD),
        .y(pc_nextbrFD)
    );
    //mux for jump
    // jump=1, choose pc_next
    mux2to1 #(32) mux_pc_jump(
        .a({pc_plus4D[31:28],instrD[25:0],2'b00}),
        .b(pc_nextbrFD),
        .s(jumpD),
        .y(pc_next_FD)
    );
    //regfile(在译码和写回时)
    regfile rf(
        .clk(~clk),   //注意~clk
        .we(regWriteW),
        .ra1(rsD),
        .ra2(rtD),
        .wa(writeRegW),     //for load and R instructor
        .din(resultW),
        .dout1(srcaD),
        .dout2(srcbD)
    );

    //fetch stage
    flopenr #(32) pcReg(
        .clk(clk),
        .rst(rst),
        .en(~stallF),
        .d(pc_next_FD),
        .q(pcF)
    );

    add_32 add_pc(  // add for pc+4
        .a(pcF),
        .b(32'h4),
        .y(pc_plus4F)
    );

    //decode stage
    // reg for pc_plus4D
    flopenr #(32) r1D(
        .clk(clk),
        .rst(rst),
        .en(~stallD),
        .d(pc_plus4F),
        .q(pc_plus4D)
    );
    // reg for instructor
    flopenr #(32) r2D(
        .clk(clk),
        .rst(rst),
        .en(~stallD),
        .d(instrF),
        .q(instrD)
    );
    // 16 -> 32
    // andi, xori, lui, ori->zero_extend, other->sign_extend
    signext signExtend(
        .signal(instrD[15:0]),
        .sign_extend(sign_extD),
        .y(signImmD)
    );

    //shift left for immediate
    sl2 sl2_immed(
        .a(signImmD),
        .y(signImmD_sl2D)
    );
    //add for beq
    add_32 pc_add_beq(
        .a(pc_plus4D),
        .b(signImmD_sl2D),
        .y(pc_branchD)
    );
    //mux for compare source1
    //forwardAD=1, choose ALUOutM
    mux2to1 #(32) mux_cmp_src1(
        .a(ALUOutM),
        .b(srcaD),
        .s(forwardAD),
        .y(srca2D)
    );
    //mux for compare source2
    //forwardBD=1, choose ALUOutM
    mux2to1 #(32) mux_cmp_src2(
        .a(ALUOutM),
        .b(srcbD),
        .s(forwardBD),
        .y(srcb2D)
    );
    //compare
    eqcmp comp(
        .a(srca2D),
        .b(srcb2D),
        .y(euqalD)
    );
    
    assign opD    = instrD[31:26];
    assign functD = instrD[5:0];
    assign rsD    = instrD[25:21];
    assign rtD    = instrD[20:16];
    assign rdD    = instrD[15:11];
    assign saD    = instrD[10:6];
    
    //use for debug
    wire [39:0] asciiD;
    instdec instdec1(
        .instr(instrD),
        .ascii(asciiD)
    );

    //execute stage
    flopenrc #(12) regE(clk,rst,~stallE,flushE,{memToRegD,memWriteD,aluSrcD,regDstD,regWriteD,ALUControlD},
    {memToRegE,memWriteE,aluSrcE,regDstE,regWriteE,ALUControlE});
    flopenrc #(32) r1E(clk,rst,~stallE,flushE,srcaD,srcaE);  //从寄存器读出来的数据A
    flopenrc #(32) r2E(clk,rst,~stallE,flushE,srcbD,srcbE);  //从寄存器读出来的数据B
    flopenrc #(32) r3E(clk,rst,~stallE,flushE,signImmD,signImmE);  //从decode阶段到execute阶段扩展后的立即数
	flopenrc #(5) r4E(clk,rst,~stallE,flushE,rsD,rsE);
	flopenrc #(5) r5E(clk,rst,~stallE,flushE,rtD,rtE);
	flopenrc #(5) r6E(clk,rst,~stallE,flushE,rdD,rdE);
    flopenrc #(5) r7E(clk,rst,~stallE,flushE,saD,saE);
    flopenrc #(1) r8E(clk,rst,~stallE,flushE,hilo_weD,hilo_weE);
    flopenrc #(1) r9E(clk,rst,~stallE,flushE,isDivD,isDivE);

    mux3to1 #(32) mux_alu_src1(srcaE,resultW,ALUOutM,forwardAE,srca2E);  //选择ALU的第一个数据源
    mux3to1 #(32) mux_alu_src2(srcbE,resultW,ALUOutM,forwardBE,srcb2E);  //选择ALU的第二个数据源
    mux2to1 #(32) mux_alu_src3(signImmE,srcb2E,aluSrcE,srcb3E);

    mux3to1 #(64) mux_alu_hilo(hilo_oW, hilo_iW, hilo_iM, forwardHiloE, hilo_for_aluE);  // choose the right hilo input for alu

    ALU alu(
        .A(srca2E),
        .B(srcb3E),
        .sa(saE),
        .f(ALUControlE),        // ALUControl
        .hilo(hilo_for_aluE),  // the output of hilo reg
        .res(alu_resultE),
        .overFlow(overFlow),
        .zero(zero)
    );
    
    divider_primary divider(
        .clk(clk), 
        .rst(rst),
        .ALUControl_i(ALUControlE),
	    .opdata1_i(srca2E),
	    .opdata2_i(srcb3E),
	    .annul_i(1'b0),        // no half-stopping
	    .result_o(div_resultE),
        .stall_div(stall_divE)
    );

    mux3to1 #(5) writeReg_src(rtE,rdE,rtE,regDstE,writeRegE);           // **有待更正第三个参数**
    mux2to1 #(64) mux_aluout(div_resultE,alu_resultE,isDivE,ALUOutE);  // decide the final alu resut

    //mem stage
    flopr #(3) regM(clk,rst,{memToRegE,memWriteE,regWriteE},{memToRegM,memWriteM,regWriteM});
    flopr #(32) r1M(clk,rst,srcb2E,writeDataM);       //连接到数据存储器的写数据端口
    flopr #(32) r2M(clk,rst,ALUOutE[31:0],ALUOutM);   //连接到数据存储器的写数据地址端口
    flopr #(5) r3M(clk,rst,writeRegE,writeRegM); 
    flopr #(1) r4M(clk,rst,hilo_weE,hilo_weM);
    flopr #(64) r5M(clk,rst,ALUOutE,hilo_iM);
  
    //write back stage
    flopr #(2) regW(clk,rst,{memToRegM,regWriteM},{memToRegW,regWriteW});
    flopr #(32) r1W(clk,rst,readDataM,readDataW);
    flopr #(32) r2W(clk,rst,ALUOutM,ALUOutW);
    flopr #(5) r3W(clk,rst,writeRegM,writeRegW);
    flopr #(1) r4W(clk,rst,hilo_weM, hilo_weW);
    flopr #(64) r5W(clk,rst,hilo_iM,hilo_iW);

    // hilo_reg
    hilo_reg hilo_reg(
        .clk(clk),
        .rst(rst),
        .we(hilo_weW),
        .hi(hilo_iW[63:32]),
        .lo(hilo_iW[31:0]),
        .hi_o(hilo_oW[63:32]),
        .lo_o(hilo_oW[31:0])
    );

    mux2to1 #(32) mux_res(readDataW,ALUOutW,memToRegW,resultW); //选择写回寄存器的数据来源

endmodule