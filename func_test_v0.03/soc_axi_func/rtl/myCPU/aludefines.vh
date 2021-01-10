//alu defines
// logic instr
`define ALU_AND             6'b00_0000
`define ALU_OR              6'b00_0001
`define ALU_XOR             6'b00_1010
`define ALU_NOR             6'b00_1011
`define ALU_LUI             6'b00_1111

// shift instr
`define ALU_SLL             6'b01_0110
`define ALU_SRL             6'b01_0111
`define ALU_SRA             6'b01_1000
`define ALU_SLLV            6'b00_0101
`define ALU_SRLV            6'b00_0110
`define ALU_SRAV            6'b00_0111

// move instr
`define ALU_MTHI            6'b01_1011
`define ALU_MTLO            6'b01_1100
`define ALU_MFHI            6'b10_0000
`define ALU_MFLO            6'b10_0001

// arithmetic instr
`define ALU_ADD             6'b00_0010
`define ALU_ADDU            6'b01_0000
`define ALU_SUB             6'b00_0011
`define ALU_SUBU            6'b01_0001
`define ALU_SLT             6'b00_0100
`define ALU_SLTU            6'b00_1000
`define ALU_MULT            6'b00_1101
`define ALU_MULTU           6'b00_1001
`define ALU_DIV             6'b00_1110
`define ALU_DIVU            6'b00_1100

// privileged instr
`define ALU_MTC0             6'b01_0010
`define ALU_MFC0             6'b01_0011

`define ALU_GEZ             6'b01_0100
`define ALU_LTZ             6'b01_0101

`define ALU_EQ              6'b01_1001
`define ALU_NEQ             6'b01_1010

// abs
`define ALU_ABS             6'b10_1111

`define ALU_DEFAULT         6'b01_1111