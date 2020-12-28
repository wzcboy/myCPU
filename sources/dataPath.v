`timescale 1ns / 1ps

module dataPath(
    input clk,rst,
    //fetch stage
    input [31:0] instrF,
    output [31:0] pcF,
    //decode stage
    input regWriteD, memToRegD,memWriteD,aluSrcD,regDstD,branchD,jumpD,
    input [2:0] ALUControlD,
    output [5:0] opD,functD,
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
    wire [31:0] pc_plus4D,instrD;
    wire forwardAD, forwardBD,euqalD,pcSrcD;
    wire [4:0] rsD,rtD,rdD;
    wire stallD, flushD;
    wire [31:0] signImmD,signImmD_sl2D;
    wire [31:0] srcaD,srca2D,srcbD,srcb2D;
    //execute stage
    wire [1:0] forwardAE,forwardBE;
    wire [4:0] rsE,rtE,rdE;
    wire flushE;
    wire [4:0] writeRegE;
    wire [31:0] signImmE;
    wire [31:0] srcaE,srca2E,srcbE,srcb2E,srcb3E;
    wire memToRegE,memWriteE,aluSrcE,regDstE,regWriteE;
    wire [2:0] ALUControlE;
    wire [31:0] ALUOutE;
    //mem stage
    wire [4:0] writeRegM;
    wire memToRegM,memWriteM,regWriteM;
    //write back stage
    wire [4:0] writeRegW;
    wire [31:0] ALUoutW,readDataW,resultW;
    wire memToRegW,regWriteW;

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
    //mem stage
    .writeRegM(writeRegM),
    .regWriteM(regWriteM),
    .memToRegM(memToRegM),

    //write back stage
    .writeRegW(writeRegW),
    .regWriteW(regWriteW)
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
    signext signExtend(
        .signal(instrD[15:0]),
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
    
    assign opD = instrD[31:26];
    assign functD = instrD[5:0];
    assign rsD = instrD[25:21];
    assign rtD = instrD[20:16];
    assign rdD = instrD[15:11];

    //execute stage
    floprc #(8) regE(clk,rst,flushE,{memToRegD,memWriteD,aluSrcD,regDstD,regWriteD,ALUControlD},
    {memToRegE,memWriteE,aluSrcE,regDstE,regWriteE,ALUControlE});
    floprc #(32) r1E(clk,rst,flushE,srcaD,srcaE);  //从寄存器读出来的数据A
    floprc #(32) r2E(clk,rst,flushE,srcbD,srcbE);  //从寄存器读出来的数据B
    floprc #(32) r3E(clk,rst,flushE,signImmD,signImmE);  //从decode阶段到execute阶段扩展后的立即数
	floprc #(5) r4E(clk,rst,flushE,rsD,rsE);
	floprc #(5) r5E(clk,rst,flushE,rtD,rtE);
	floprc #(5) r6E(clk,rst,flushE,rdD,rdE);

    mux3to1 #(32) mux_alu_src1(srcaE,resultW,ALUOutM,forwardAE,srca2E);  //选择ALU的第一个数据源
    mux3to1 #(32) mux_alu_src2(srcbE,resultW,ALUOutM,forwardBE,srcb2E);  //选择ALU的第二个数据源
    mux2to1 #(32) mux_alu_src3(signImmE,srcb2E,aluSrcE,srcb3E);
    ALU alu(
        .A(srca2E),
        .B(srcb3E),   
        .f(ALUControlE),      //ALUControl
        .s(ALUOutE),
        .overFlow(overFlow),
        .zero(zero)
    );

    mux2to1 #(5) writeReg_src(rdE,rtE,regDstE,writeRegE); 

    //mem stage
    flopr #(8) regM(clk,rst,{memToRegE,memWriteE,regWriteE},
    {memToRegM,memWriteM,regWriteM});
    flopr #(32) r1M(clk,rst,srcb2E,writeDataM);  //连接到数据存储器的写数据端口
    flopr #(32) r2M(clk,rst,ALUOutE,ALUOutM);   //连接到数据存储器的写数据地址端口
    flopr #(5) r3M(clk,rst,writeRegE,writeRegM); 
  
    //write back stage
    flopr #(8) regW(clk,rst,{memToRegM,regWriteM},
    {memToRegW,regWriteW});
    flopr #(32) r1W(clk,rst,readDataM,readDataW);
    flopr #(32) r2W(clk,rst,ALUOutM,ALUoutW);
    flopr #(5) r3W(clk,rst,writeRegM,writeRegW); 

    mux2to1 #(32) mux_res(readDataW,ALUoutW,memToRegW,resultW); //选择写回寄存器的数据来源

endmodule