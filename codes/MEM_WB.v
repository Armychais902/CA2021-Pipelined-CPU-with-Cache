module MEM_WB
(
    clk_i,
	start_i,
	MemStall_i,
	RegWrite_i,
	MemtoReg_i,
	ALUResult_i,
	MemData_i,
	RDaddr_i,
	RegWrite_o,
	MemtoReg_o,
	ALUResult_o,
	MemData_o,
	RDaddr_o
);

input           clk_i;
input 			start_i;
input			MemStall_i;
input			RegWrite_i, MemtoReg_i;
input	[4:0]   RDaddr_i;
input	[31:0]  ALUResult_i, MemData_i;
output reg      RegWrite_o, MemtoReg_o;
output	[4:0]   RDaddr_o;
reg		[4:0]   RDaddr_o;
output	[31:0]  ALUResult_o, MemData_o;
reg		[31:0]  ALUResult_o, MemData_o;

always @(posedge clk_i or negedge start_i) begin
	if (!start_i)	begin
		RegWrite_o <= 1'b0;
		MemtoReg_o <= 1'b0;
		RDaddr_o <= 5'b0;
		ALUResult_o <= 32'b0;
		MemData_o <= 32'b0;
	end
	else if (!MemStall_i)	begin
		RegWrite_o <= RegWrite_i;
		MemtoReg_o <= MemtoReg_i;
		RDaddr_o <= RDaddr_i;
		ALUResult_o <= ALUResult_i;
		MemData_o <= MemData_i;
	end
end

endmodule