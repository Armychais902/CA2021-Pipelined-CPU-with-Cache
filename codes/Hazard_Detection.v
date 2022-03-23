module Hazard_Detection
(
    RS1addr_i,
	RS2addr_i,
	MemRead_i,
	RDaddr_i,
	stall_o,
	PCWrite_o,
	NoOp_o,
);

input MemRead_i;
input [4:0] RS1addr_i, RS2addr_i;
input [4:0] RDaddr_i;

output reg stall_o, PCWrite_o, NoOp_o;

always @(MemRead_i or RS1addr_i or RS2addr_i or RDaddr_i)   begin
    if (MemRead_i && ((RDaddr_i == RS1addr_i) || (RDaddr_i == RS2addr_i)))  begin
        NoOp_o = 1'b1;
        PCWrite_o = 1'b0;
        stall_o = 1'b1;
    end
    else    begin
        NoOp_o = 1'b0;
        PCWrite_o = 1'b1;
        stall_o = 1'b0;
    end
end


endmodule

/* If (ID/EX.MemRead and 
((ID/EX.RegisterRd = IF/ID.RegisterRs1) or
(ID/EX.RegisterRd = IF/ID.REgisterRs2))) */