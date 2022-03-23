module ID_EX
(
    clk_i,
    start_i,
    MemStall_i,
    RegWrite_i,
    MemtoReg_i,
    MemRead_i,
	MemWrite_i,
    ALUOp_i,
    ALUSrc_i,
    RS1data_i,
    RS2data_i,
    Imm_i,
    funct_i,
    RS1addr_i,
    RS2addr_i,
    RDaddr_i,
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
	MemWrite_o,
    ALUOp_o,
    ALUSrc_o,
    RS1data_o,
    RS2data_o,
    Imm_o,
    funct_o,
    RS1addr_o,
    RS2addr_o,
    RDaddr_o   
);

input           clk_i;
input           start_i;
input           MemStall_i;
input           RegWrite_i, MemtoReg_i, MemRead_i, MemWrite_i, ALUSrc_i;
input [1:0]     ALUOp_i;
input [4:0]     RS1addr_i, RS2addr_i, RDaddr_i;
input [31:0]    RS1data_i, RS2data_i;
input [31:0]    Imm_i;
input [9:0]     funct_i;
output reg      RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o, ALUSrc_o;
output [1:0]    ALUOp_o;
reg    [1:0]    ALUOp_o;
output [4:0]    RS1addr_o, RS2addr_o, RDaddr_o;
reg    [4:0]    RS1addr_o, RS2addr_o, RDaddr_o;
output [31:0]   RS1data_o, RS2data_o;
reg    [31:0]   RS1data_o, RS2data_o;
output [31:0]   Imm_o;
reg    [31:0]   Imm_o;
output [9:0]    funct_o;
reg    [9:0]    funct_o;


always @(posedge clk_i or negedge start_i) begin
    if (!start_i)   begin
        RegWrite_o <= 1'b0;
        MemtoReg_o <= 1'b0;
        MemRead_o <= 1'b0;
        MemWrite_o <= 1'b0;
        ALUSrc_o <= 1'b0;
        ALUOp_o <= 2'b0;
        RS1addr_o <= 5'b0;
        RS2addr_o <= 5'b0;
        RDaddr_o <= 5'b0;
        RS1data_o <= 32'b0;
        RS2data_o <= 32'b0;
        Imm_o <= 32'b0;
        funct_o <= 10'b0;
    end
    else if (!MemStall_i) begin
        RegWrite_o <= RegWrite_i;
        MemtoReg_o <= MemtoReg_i;
        MemRead_o <= MemRead_i;
        MemWrite_o <= MemWrite_i;
        ALUSrc_o <= ALUSrc_i;
        ALUOp_o <= ALUOp_i;
        RS1addr_o <= RS1addr_i;
        RS2addr_o <= RS2addr_i;
        RDaddr_o <= RDaddr_i;
        RS1data_o <= RS1data_i;
        RS2data_o <= RS2data_i;
        Imm_o <= Imm_i;
        funct_o <= funct_i; 
    end
end

endmodule