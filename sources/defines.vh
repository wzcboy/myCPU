// macro definiton


`define EXE_NOP         6'b000000 
//------------------instr op---------------------
`define EXE_ZERO_OP     6'b000000
`define EXE_REGIMM_OP   6'b000001
// logic instr
`define EXE_ANDI_OP		6'b001100
`define EXE_XORI_OP		6'b001110
`define EXE_LUI_OP		6'b001111
`define EXE_ORI_OP		6'b001101

// arithmetic instr
`define EXE_ADDI_OP     6'b001000
`define EXE_ADDIU_OP    6'b001001
`define EXE_SLTI_OP     6'b001010
`define EXE_SLTIU_OP    6'b001011

// jump and branch instr
`define EXE_J_OP        6'b000010
`define EXE_JAL_OP      6'b000011
`define EXE_BEQ_OP      6'b000100
`define EXE_BGTZ_OP     6'b000111
`define EXE_BLEZ_OP     6'b000110
`define EXE_BNE_OP      6'b000101

// load and store instr
`define EXE_LB_OP       6'b100000
`define EXE_LBU_OP      6'b100100
`define EXE_LH_OP       6'b100001
`define EXE_LHU_OP      6'b100101
`define EXE_LW_OP       6'b100011
`define EXE_SB_OP       6'b101000
`define EXE_SH_OP       6'b101001
`define EXE_SW_OP       6'b101011

// privileged instr
`define EXE_PRI_OP      6'b010000

//-----------------instr funct---------------------
// logic instr
`define EXE_AND 		6'b100100
`define EXE_OR 			6'b100101
`define EXE_XOR 		6'b100110
`define EXE_NOR			6'b100111

// shift instr
`define EXE_SLL         6'b000000
`define EXE_SRL         6'b000010
`define EXE_SRA         6'b000011
`define EXE_SLLV        6'b000100
`define EXE_SRLV        6'b000110
`define EXE_SRAV        6'b000111

// move instr
`define EXE_MFHI  		6'b010000
`define EXE_MTHI  		6'b010001
`define EXE_MFLO  		6'b010010
`define EXE_MTLO  		6'b010011

// arithmetic instr
`define EXE_ADD         6'b100000
`define EXE_ADDU        6'b100001
`define EXE_SUB         6'b100010
`define EXE_SUBU        6'b100011
`define EXE_SLT         6'b101010
`define EXE_SLTU        6'b101011
`define EXE_MULT        6'b011000
`define EXE_MULTU       6'b011001
`define EXE_DIV         6'b011010
`define EXE_DIVU        6'b011011

// jump instr
`define EXE_JR          6'b001000
`define EXE_JALR        6'b001001

// break and syscall
`define EXE_BREAK       6'b001101
`define EXE_SYSCALL     6'b001100

// ----------------instr rt or rs--------------
// rt
`define EXE_BLTZ        5'b00000
`define EXE_BLTZAL      5'b10000
`define EXE_BGEZ        5'b00001
`define EXE_BGEZAL      5'b10001

// rs
`define EXE_MTC0        5'b00100
`define EXE_MFC0        5'b00000

// ----------------instr all-------------
`define EXE_ERET        32'b01000010000000000000000000011000

// ----------------exception type----------------
`define EXC_TYPE_INT            32'h0000_0001  
`define EXC_TYPE_INT_FORWARD    32'h0000_0002
`define EXC_TYPE_ADEL           32'h0000_0004  
`define EXC_TYPE_ADES           32'h0000_0005  
`define EXC_TYPE_SYS            32'h0000_0008  
`define EXC_TYPE_BP             32'h0000_0009  
`define EXC_TYPE_RI             32'h0000_000a  
`define EXC_TYPE_OV             32'h0000_000c
`define EXC_TYPE_ERET           32'h0000_000e  
`define EXC_TYPE_NOEXC          32'h0000_0000


// CP0
`define CP0_REG_BADVADDR    5'b01000       
`define CP0_REG_COUNT       5'b01001        
`define CP0_REG_COMPARE     5'b01011      
`define CP0_REG_STATUS      5'b01100       
`define CP0_REG_CAUSE       5'b01101       
`define CP0_REG_EPC         5'b01110          
`define CP0_REG_PRID        5'b01111         
`define CP0_REG_CONFIG      5'b10000       