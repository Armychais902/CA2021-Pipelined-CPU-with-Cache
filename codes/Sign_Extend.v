`include "constants.vh"

module Sign_Extend
(
    data_i,
    data_o
);

// Ports
input   [31:0]   data_i;
output  [31:0]   data_o;
reg     [11:0]   output_reg;

/*
Itype => addi/srai funct
lw
sw
beq
*/


assign data_o = {{20{output_reg[11]}}, output_reg[11:0]};

always @(data_i)    begin
    if (data_i[6:0] == `Itype_Opcode)   begin
        if (data_i[14:12] == `ADDI_funct)   begin
            output_reg[11:0] = data_i[31:20];
        end
        else    begin   // SRAI, no need to process imm in ALU this time
            output_reg = {{7{data_i[24]}}, data_i[24:20]};
        end
    end
    else if (data_i[6:0] == `lw_Opcode) begin
        output_reg[11:0] = data_i[31:20];
    end
    else if (data_i[6:0] == `sw_Opcode) begin
        output_reg[11:5] = data_i[31:25];
        output_reg[4:0] = data_i[11:7];
    end
    else if (data_i[6:0] == `beq_Opcode)    begin
        output_reg[11] = data_i[31];
        output_reg[9:4] = data_i[30:25];
        output_reg[3:0] = data_i[11:8];
		output_reg[10] = data_i[7];
    end
end

endmodule