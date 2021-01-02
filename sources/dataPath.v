`timescale 1ns / 1ps

module dataPath(
    input clk,rst,
    // fetch stage
    input [31:0] instrF,
    output [31:0] pcF,
    // decode stage
    input regWriteD,memToRegD,memReadD,memWriteD,aluSrcD,regDstD,
    input branchD,jumpD,jalD,jrD,balD,
    input [5:0] ALUControlD,
    input sign_extD,
    input hilo_weD,
    input isDivD,
    output [31:0] instrD,
    //execute stage
    
    // mem stage
    input [31:0] readDataM,
    output [31:0] ALUOutM,writeDataM,
    output [5:0] opM,
    output mem_enM,
    // write back stage
    output [31:0] pcW, resultW,
    output [4:0] writeRegW,
    output regWriteW
    );

    // fetch stage
    wire stallF;
    // FD
    wire [31:0] pc_next_FD, pc_nextbrFD, pc_plus4F, pc_plus8F,pc_branchD,pc_jumpD;
    // decode stage
    wire [31:0] pcD, pc_plus4D, pc_plus8D;
    wire forwardAD, forwardBD,euqalD,pcSrcD;
    wire [5:0] opD, functD;
    wire [4:0] rsD,rtD,rdD,saD;
    wire stallD, flushD;
    wire [31:0] signImmD,signImmD_sl2D;
    wire [31:0] srcaD,srca2D,srcbD,srcb2D;
    // execute stage
    wire [31:0] pcE, pc_plus8E;
    wire [1:0] forwardAE,forwardBE, forwardHiloE;
    wire [4:0] rsE,rtE,rdE,saE;
    wire [5:0] opE;
    wire stallE, flushE;
    wire [4:0] writeRegE,writeReg2E;
    wire [31:0] signImmE;
    wire [31:0] srcaE,srca2E,srcbE,srcb2E,srcb3E;
    wire memToRegE,memReadE,memWriteE,aluSrcE,regWriteE,regDstE;
    wire jalE, jrE, balE;
    wire [5:0] ALUControlE;
    wire [63:0] ALUOutE;
    wire [31:0] ALUOut2E;
    wire [63:0] hilo_for_aluE;
    wire hilo_weE;
    wire [63:0] alu_resultE, div_resultE;
    wire stall_divE, isDivE;
    // mem stage
    wire [4:0] writeRegM;
    wire memToRegM,memReadM,memWriteM,regWriteM;
    wire hilo_weM;
    wire [63:0] hilo_iM;
    wire [31:0] pcM;
    // write back stage
    wire [31:0] ALUOutW,readDataW;
    wire memToRegW;
    wire hilo_weW;
    wire [63:0] hilo_iW, hilo_oW;

    wire zero,overFlow;               // **有待更新**

    
    //冒险控制
    hazard h(
     // fetch stage
    .stallF(stallF),
    // decode stage
    .rsD(rsD), 
    .rtD(rtD),
    .branchD(branchD),
    .jumpD(jumpD),
    .jrD(jrD),
    .balD(balD),
    .forwardAD(forwardAD), 
    .forwardBD(forwardBD),
    .stallD(stallD),
    // excute stage
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
    // mem stage
    .writeRegM(writeRegM),
    .regWriteM(regWriteM),
    .memToRegM(memToRegM),
    .hilo_weM(hilo_weM),
    // write back stage
    .writeRegW(writeRegW),
    .regWriteW(regWriteW),
    .hilo_weW(hilo_weW)
    );

    // mux for beq
    // pcSrc=1, choose pc_branch
    mux2to1 #(32) mux_pc_beq(
        .a(pc_branchD),
        .b(pc_plus4F),
        .s(pcSrcD),
        .y(pc_nextbrFD)
    );
    // mux for jump
    // jump=1, choose pc_next
    mux2to1 #(32) mux_pc_jump(
        .a(pc_jumpD),
        .b(pc_nextbrFD),
        .s(jumpD | jalD | jrD),
        .y(pc_next_FD)
    );

    // fetch stage
    pc_reg #(32) pcReg(
        .clk(clk),
        .rst(rst),
        .en(~stallF),
        .d(pc_next_FD),
        .q(pcF)
    );


    // add for pc+4 and pc+8
    add_32 add_pc1(pcF, 32'h4, pc_plus4F);
    add_32 add_pc2(pcF, 32'h8, pc_plus8F);

    // decode stage
    flopenr #(32) r1D(clk,rst,~stallD,pc_plus4F,pc_plus4D);    // reg for pc_plus4D
    flopenr #(32) r2D(clk,rst,~stallD,instrF,instrD);          // reg for instructor
    flopenr #(32) r3D(clk,rst,~stallD,pc_plus8F,pc_plus8D);    // reg for pc_plus4D
    flopenr #(32) r4D(clk,rst,~stallD,pcF,pcD);    // reg for pc_plus4D
    
    // regfile
    regfile rf(
        .clk(~clk),         //notice:~clk
        .we(regWriteW),
        .ra1(rsD),
        .ra2(rtD),
        .wa(writeRegW),     //for load and R instructor
        .din(resultW),
        .dout1(srcaD),
        .dout2(srcbD)
    );

    // 16 -> 32
    // andi, xori, lui, ori->zero_extend, other->sign_extend
    signext signExtend(
        .signal(instrD[15:0]),
        .sign_extend(sign_extD),
        .y(signImmD)
    );

    // shift left for immediate
    sl2 sl2_immed(
        .a(signImmD),
        .y(signImmD_sl2D)
    );
    // add for beq
    add_32 pc_add_beq(
        .a(pc_plus4D),
        .b(signImmD_sl2D),
        .y(pc_branchD)
    );

    // mux for compare source
    // forwardAD=1, choose ALUOutM; forwardBD=1, choose ALUOutM
    mux2to1 #(32) mux_cmp_src1(ALUOutM, srcaD, forwardAD, srca2D);
    mux2to1 #(32) mux_cmp_src2(ALUOutM, srcbD, forwardBD, srcb2D);
    // j, jal -> second argument, jr, jalr -> GPR[rs] 
    mux2to1 #(32) mux_jump_addr(srca2D, {pc_plus4D[31:28],instrD[25:0],2'b00}, jrD, pc_jumpD);

    // compare
    eqcmp comp(
        .a(srca2D),
        .b(srcb2D),
        .op(opD),
        .rt(rtD),
        .y(euqalD)
    );
    
    assign pcSrcD = branchD & euqalD;

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
    flopenrc #(12) regE(clk,rst,~stallE,flushE,{memToRegD,memReadD,memWriteD,aluSrcD,regDstD,regWriteD,ALUControlD},
    {memToRegE,memReadE,memWriteE,aluSrcE,regDstE,regWriteE,ALUControlE});
    flopenrc #(32) r1E(clk,rst,~stallE,flushE,srcaD,srcaE);  
    flopenrc #(32) r2E(clk,rst,~stallE,flushE,srcbD,srcbE); 
    flopenrc #(32) r3E(clk,rst,~stallE,flushE,signImmD,signImmE);
	flopenrc #(5) r4E(clk,rst,~stallE,flushE,rsD,rsE);
	flopenrc #(5) r5E(clk,rst,~stallE,flushE,rtD,rtE);
	flopenrc #(5) r6E(clk,rst,~stallE,flushE,rdD,rdE);
    flopenrc #(5) r7E(clk,rst,~stallE,flushE,saD,saE);
    flopenrc #(1) r8E(clk,rst,~stallE,flushE,hilo_weD,hilo_weE);
    flopenrc #(1) r9E(clk,rst,~stallE,flushE,isDivD,isDivE);
    flopenrc #(32) r10E(clk,rst,~stallE,flushE,pc_plus8D,pc_plus8E);
    flopenrc #(3) r11E(clk,rst,~stallE,flushE,{jalD,jrD,balD},{jalE,jrE,balE});
    flopenrc #(6) r12E(clk,rst,~stallE,flushE,opD, opE);
    flopenrc #(32) r13E(clk,rst,~stallE,flushE,pcD,pcE);

    mux3to1 #(32) mux_alu_src1(srcaE,resultW,ALUOutM,forwardAE,srca2E);  // choose the first  source for ALU
    mux3to1 #(32) mux_alu_src2(srcbE,resultW,ALUOutM,forwardBE,srcb2E);  // choose the second source for ALU
    mux2to1 #(32) mux_alu_src3(signImmE,srcb2E,aluSrcE,srcb3E);

    mux3to1 #(64) mux_alu_hilo(hilo_oW, hilo_iW, hilo_iM, forwardHiloE, hilo_for_aluE);  // choose the right hilo input for ALU

    ALU alu(
        .A(srca2E),
        .B(srcb3E),
        .sa(saE),
        .f(ALUControlE),        // ALUControl
        .hilo(hilo_for_aluE),   // the output of hilo reg
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

    mux2to1 #(5) wrmux1(rdE,rtE,regDstE,writeRegE);        
    mux2to1 #(5) wrmux2(5'b11111, writeRegE, jalE | balE | (jrE & (writeRegE==5'b0)), writeReg2E);  // for jal, bgezal, bltzal, jalr,write GPR[31]
    mux2to1 #(64) wrmux3(div_resultE,alu_resultE,isDivE,ALUOutE);                                   // decide the final alu resut,considering the div
    mux2to1 #(32) wrmux4(pc_plus8E, ALUOutE[31:0], jalE | jrE | balE, ALUOut2E);                    // jrE is for jalr
    

    //mem stage
    flopr #(4) regM(clk,rst,{memToRegE,memReadE,memWriteE,regWriteE},{memToRegM,memReadM,memWriteM,regWriteM});
    flopr #(32) r1M(clk,rst,srcb2E,writeDataM);       // write data to memory
    flopr #(32) r2M(clk,rst,ALUOut2E,ALUOutM);        // addr for write memory
    flopr #(5) r3M(clk,rst,writeReg2E,writeRegM); 
    flopr #(1) r4M(clk,rst,hilo_weE,hilo_weM);
    flopr #(64) r5M(clk,rst,ALUOutE,hilo_iM);
    flopr #(6) r6M(clk,rst,opE,opM);
    flopr #(32) r7M(clk,rst,pcE,pcM);
    
    assign mem_enM = memReadM | memWriteM;     // memory enable

    //write back stage
    flopr #(2) regW(clk,rst,{memToRegM,regWriteM},{memToRegW,regWriteW});
    flopr #(32) r1W(clk,rst,readDataM,readDataW);
    flopr #(32) r2W(clk,rst,ALUOutM,ALUOutW);
    flopr #(5) r3W(clk,rst,writeRegM,writeRegW);
    flopr #(1) r4W(clk,rst,hilo_weM, hilo_weW);
    flopr #(64) r5W(clk,rst,hilo_iM,hilo_iW);
    flopr #(32) r6W(clk,rst,pcM,pcW);

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