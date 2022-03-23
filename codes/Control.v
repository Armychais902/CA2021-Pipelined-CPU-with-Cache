`include "constants.vh"

module Control
(
    Op_i,
    NoOp_i,
	RegWrite_o,
	MemtoReg_o,
	MemRead_o,
	MemWrite_o,
	ALUOp_o,
	ALUSrc_o,
	Branch_o
);

// Ports
input           NoOp_i;
input   [6:0]   Op_i;
output          RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o, ALUSrc_o, Branch_o;
output  [1:0]   ALUOp_o;
reg     [1:0]   ALUOp_o;

assign RegWrite_o = (NoOp_i) ? 1'b0 :
                    (Op_i == `beq_Opcode || Op_i == `sw_Opcode) ? 1'b0 : 1'b1;
assign MemtoReg_o = (NoOp_i) ? 1'b0 :
                    (Op_i == `lw_Opcode) ? 1'b1 : 1'b0;
assign MemRead_o =  (NoOp_i) ? 1'b0 :
                    (Op_i == `lw_Opcode) ? 1'b1 : 1'b0;
assign MemWrite_o = (NoOp_i) ? 1'b0 :
                    (Op_i == `sw_Opcode) ? 1'b1 : 1'b0;
assign ALUSrc_o =   (NoOp_i) ? 1'b0 :
                    (Op_i == `lw_Opcode || Op_i == `sw_Opcode || Op_i == `Itype_Opcode) ? 1'b1 : 1'b0;
assign Branch_o =   (NoOp_i) ? 1'b0 :
                    (Op_i == `beq_Opcode) ? 1'b1 : 1'b0;

always @(Op_i) begin
    if (!NoOp_i)    begin
        case (Op_i)
            `Rtype_Opcode:  ALUOp_o = `Rtype_ALUOp;
            `Itype_Opcode:  ALUOp_o = `Itype_ALUOp;
            `lw_Opcode:     ALUOp_o = `lw_sw_ALUOp;
            `sw_Opcode:     ALUOp_o = `lw_sw_ALUOp;
            `beq_Opcode:    ALUOp_o = `beq_ALUOp;
        endcase
    end
    else    begin
        ALUOp_o = 2'b00;
    end
end

/* 
RegWrite_o:
    0: beq, sw
    1: else
MemtoReg_o:
    0: else
    1: lw
MemRead_o:
    0: else
    1: lw
MemWrite_o:
    0: else
    1: sw
ALUSrc_o:
    0: else
    1(imm): I-type, lw, sw
Branch_o:
    0: else
    1: beq
ALUOp_o:
    10: R-type
    00: lw, sw
    01: beq
    11: I-type
 */

endmodule