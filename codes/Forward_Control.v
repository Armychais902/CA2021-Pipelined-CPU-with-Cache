module Forward_Control
(
    EXRS1addr_i,
    EXRS2addr_i,
    MEM_RegWrite_i,
	WB_RegWrite_i,
    MEM_RDaddr_i,
	WB_RDaddr_i,
    ForwardA_o,
	ForwardB_o
);

input [4:0] EXRS1addr_i, EXRS2addr_i;
input [4:0] MEM_RDaddr_i, WB_RDaddr_i;
input       MEM_RegWrite_i, WB_RegWrite_i;
output [1:0]    ForwardA_o, ForwardB_o;
reg    [1:0]    ForwardA_o, ForwardB_o;


always @(EXRS1addr_i or EXRS2addr_i or MEM_RegWrite_i or WB_RegWrite_i or MEM_RDaddr_i or WB_RDaddr_i)  begin
    // RDaddr != 5'b0 to avoid write to register 0
    // no need to consider (not EX hazard when MEM hazard) since "else if" logic here
    if (MEM_RegWrite_i && (MEM_RDaddr_i != 5'b0) && (MEM_RDaddr_i == EXRS1addr_i))  begin
        ForwardA_o = 2'b10;
    end
    else if (WB_RegWrite_i && (WB_RDaddr_i != 5'b0) && (WB_RDaddr_i == EXRS1addr_i))    begin
        ForwardA_o = 2'b01;
    end
    else    begin
        ForwardA_o = 2'b00;
    end

    if (MEM_RegWrite_i && (MEM_RDaddr_i != 5'b0) && (MEM_RDaddr_i == EXRS2addr_i)) begin
        ForwardB_o = 2'b10; 
    end
    else if (WB_RegWrite_i && (WB_RDaddr_i != 5'b0) && (WB_RDaddr_i == EXRS2addr_i))    begin
        ForwardB_o = 2'b01;
    end
    else    begin
        ForwardB_o = 2'b00;
    end
end

endmodule


/* if (EX/MEM.RegWrite 
and (EX/MEM.RegisterRd != 0) 
and (EX/MEM.RegisterRd == ID/EX.RegisterRs1)) ForwardA = 10 
 
if (EX/MEM.RegWrite 
and (EX/MEM.RegisterRd != 0) 
and (EX/MEM.RegisterRd == ID/EX.RegisterRs2)) ForwardB = 10  */

/* if (MEM/WB.RegWrite 
and (MEM/WB.RegisterRd != 0) 
and not(EX/MEM.RegWrite and (EX/MEM.RegisterRd != 0)  
 and (EX/MEM.RegisterRd == ID/EX.RegisterRs1)) 
and (MEM/WB.RegisterRd == ID/EX.RegisterRs1)) ForwardA = 01 
 
if (MEM/WB.RegWrite 
and (MEM/WB.RegisterRd != 0) 
and not(EX/MEM.RegWrite and (EX/MEM.RegisterRd != 0)  
 and (EX/MEM.RegisterRd == ID/EX.RegisterRs2))
and (MEM/WB.RegisterRd == ID/EX.RegisterRs2)) ForwardB = 01 */