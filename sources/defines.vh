// macro definiton


`define EXE_NOP         6'b000000 
//------------------inst op---------------------
`define EXE_ZERO_OP      6'b000000
// logic inst
`define EXE_ANDI_OP		6'b001100
`define EXE_XORI_OP		6'b001110
`define EXE_LUI_OP		6'b001111
`define EXE_ORI_OP		6'b001101


//-----------------inst funct---------------------
// logic inst
`define EXE_AND 		6'b100100
`define EXE_OR 			6'b100101
`define EXE_XOR 		6'b100110
`define EXE_NOR			6'b100111

