module IF_ID
(
    clk_i,  
    start_i,
    flush_i,
    stall_i,
    MemStall_i,
    PC_i,   
    instr_i,
    PC_o,   
    instr_o
);

input               clk_i, flush_i, stall_i, MemStall_i;
input               start_i;
input      [31:0]   PC_i, instr_i;
output reg [31:0]   PC_o, instr_o;

always @(posedge clk_i or negedge start_i) begin
    if (!start_i)   begin
        PC_o <= 32'b0;
        instr_o <= 32'b0;
    end
    else if (flush_i)   begin
        instr_o <= 32'b0;
    end
    else if (!MemStall_i && !stall_i)   begin
        PC_o <= PC_i;
        instr_o <= instr_i;
    end
end

endmodule