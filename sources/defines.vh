// macro definiton


`define EXE_NOP         6'b000000 
//------------------instr op---------------------
`define EXE_ZERO_OP      6'b000000
// logic instr
`define EXE_ANDI_OP		6'b001100
`define EXE_XORI_OP		6'b001110
`define EXE_LUI_OP		6'b001111
`define EXE_ORI_OP		6'b001101


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