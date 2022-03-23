// Opcodes
`define Rtype_Opcode    7'b0110011
`define Itype_Opcode    7'b0010011
`define lw_Opcode       7'b0000011
`define sw_Opcode       7'b0100011
`define beq_Opcode      7'b1100011

// ALUOps
`define Rtype_ALUOp     2'b10
`define Itype_ALUOp     2'b11
`define lw_sw_ALUOp     2'b00
`define beq_ALUOp       2'b01

// R type's functs
`define AND_funct       10'b0000000111
`define XOR_funct       10'b0000000100
`define SLL_funct       10'b0000000001
`define ADD_funct       10'b0000000000
`define SUB_funct       10'b0100000000
`define MUL_funct       10'b0000001000

// I type's funct3
`define ADDI_funct      3'b000
`define SRAI_funct      3'b101

// ALUCtrls
`define ADD_ALUCtrl     4'b0010
`define SUB_ALUCtrl     4'b0110
`define AND_ALUCtrl     4'b0000
`define XOR_ALUCtrl     4'b0001
`define SLL_ALUCtrl     4'b1000
`define MUL_ALUCtrl     4'b1010
`define SRAI_ALUCtrl    4'b1100