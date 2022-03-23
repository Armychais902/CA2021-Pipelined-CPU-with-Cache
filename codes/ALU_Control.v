`include "constants.vh"

module ALU_Control
(
    funct_i,
    ALUOp_i,
    ALUCtrl_o   // 4 bits now
);

// Ports
input   [9:0]    funct_i;
input   [1:0]    ALUOp_i;
output  [3:0]    ALUCtrl_o;
reg     [3:0]    ALUCtrl_o;

always @(funct_i or ALUOp_i) begin
    case(ALUOp_i)
        `Rtype_ALUOp:
            case(funct_i)
                `AND_funct: ALUCtrl_o = `AND_ALUCtrl;
                `XOR_funct: ALUCtrl_o = `XOR_ALUCtrl;
                `SLL_funct: ALUCtrl_o = `SLL_ALUCtrl;
                `ADD_funct: ALUCtrl_o = `ADD_ALUCtrl;
                `SUB_funct: ALUCtrl_o = `SUB_ALUCtrl;
                `MUL_funct: ALUCtrl_o = `MUL_ALUCtrl;
            endcase
        `Itype_ALUOp:
            case(funct_i[2:0])
                `ADDI_funct: ALUCtrl_o = `ADD_ALUCtrl;
                `SRAI_funct: ALUCtrl_o = `SRAI_ALUCtrl;
            endcase
        `lw_sw_ALUOp:
            ALUCtrl_o = `ADD_ALUCtrl;
        `beq_ALUOp:
            ALUCtrl_o = `SUB_ALUCtrl;
    endcase
end

endmodule