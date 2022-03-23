module CPU
(
    clk_i, 
    rst_i,
    start_i,
    mem_ack_i,
    mem_data_i,
    mem_addr_o,
    mem_data_o,
    mem_enable_o,
    mem_write_o
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;

// Data memory
input          mem_ack_i; 	
input  [255:0] mem_data_i;

output         mem_enable_o; 
output         mem_write_o; 
output [31:0]  mem_addr_o; 	
output [255:0] mem_data_o; 


wire [31:0] instruction, instr_addr;
wire [31:0] MEM_ALUResult, RS1data, RS2data;
wire [31:0] EX_RS2data;
wire [31:0] RDdata;
wire [31:0] extended_imm;
wire [4:0]  RDaddr;
wire [4:0]  MEM_RDaddr;
wire [4:0] WB_RDaddr;
wire Branch, NoOp;
wire PC_select;
wire Stall;
wire PCWrite;
wire MemRead;
wire MEM_RegWrite;
wire WB_RegWrite;
wire MemStall;

reg PCWrite_reg;
reg Stall_reg;   // stall = 1 if stall
reg NoOp_reg;
reg PC_select_reg;   // PC = PC + 4
reg MemStall_reg;

always @(Stall) begin
    Stall_reg <= Stall;
end

always @(PCWrite)  begin
    PCWrite_reg <= PCWrite;
end

always @(NoOp)  begin
    NoOp_reg <= NoOp;
end

always @(PC_select)  begin
    PC_select_reg <= PC_select;
end

always @(MemStall) begin
    MemStall_reg <= MemStall;
end

/* OK, OK */
wire        ID_RegWrite, ID_MemtoReg, ID_MemRead, ID_MemWrite, ID_ALUSrc;
wire [1:0]  ID_ALUOp;
Control Control(
    .Op_i       (instruction[6:0]),
    .NoOp_i     (NoOp_reg), // need initial value
    .RegWrite_o (ID_RegWrite),
    .MemtoReg_o (ID_MemtoReg),
    .MemRead_o  (ID_MemRead),
	.MemWrite_o (ID_MemWrite),
    .ALUOp_o    (ID_ALUOp),
    .ALUSrc_o   (ID_ALUSrc),
    .Branch_o   (Branch)
);


/* OK, OK */
And And_Branch(
    .data1_i    (Branch),
    .data2_i    ((RS1data == RS2data) ? 1'b1 : 1'b0),
    .data_o     (PC_select)
);


/* OK, OK */
wire [31:0] IF_ID_PC_o;
IF_ID IF_ID(
    .clk_i      (clk_i),
    .start_i    (start_i),
    .flush_i    (PC_select_reg),    // initial value
    .stall_i    (Stall_reg),    // initial value
    .MemStall_i (MemStall_reg),
    .PC_i       (instr_addr),
    .instr_i    (Instruction_Memory.instr_o),
    .PC_o       (IF_ID_PC_o),
    .instr_o    (instruction)  // connect to multiple
);


wire        EX_RegWrite, EX_MemtoReg, EX_MemWrite, EX_ALUSrc;
wire [1:0]  EX_ALUOp;
wire [4:0]  EX_RS1addr, EX_RS2addr;
wire [9:0]  EX_funct;
wire [31:0] MUX_EX_RS1data, MUX_EX_RS2data;
wire [31:0] EX_Imm;

/* OK, OK */
ID_EX ID_EX(
    .clk_i      (clk_i),
    .start_i    (start_i),
    .MemStall_i (MemStall_reg),
    .RegWrite_i (ID_RegWrite),
    .MemtoReg_i (ID_MemtoReg),
    .MemRead_i  (ID_MemRead),
	.MemWrite_i (ID_MemWrite),
    .ALUOp_i    (ID_ALUOp),
    .ALUSrc_i   (ID_ALUSrc),
    .RS1data_i  (RS1data),
    .RS2data_i  (RS2data),
    .Imm_i      (extended_imm),
    .funct_i    ({instruction[31:25], instruction[14:12]}),
    .RS1addr_i  (instruction[19:15]),
    .RS2addr_i  (instruction[24:20]),
    .RDaddr_i   (instruction[11:7]),
    .RegWrite_o (EX_RegWrite),
    .MemtoReg_o (EX_MemtoReg),
    .MemRead_o  (MemRead),
	.MemWrite_o (EX_MemWrite),
    .ALUOp_o    (EX_ALUOp),
    .ALUSrc_o   (EX_ALUSrc),
    .RS1data_o  (MUX_EX_RS1data),
    .RS2data_o  (MUX_EX_RS2data),
    .Imm_o      (EX_Imm),
    .funct_o    (EX_funct),
    .RS1addr_o  (EX_RS1addr),
    .RS2addr_o  (EX_RS2addr),
    .RDaddr_o   (RDaddr)
);


wire            MEM_MemtoReg, MEM_MemRead, MEM_MemWrite;
wire [31:0]     MEM_RS2data;
wire [31:0]     ALUResult;
/* OK, OK */
EX_MEM EX_MEM(
    .clk_i       (clk_i),
    .start_i     (start_i),
    .MemStall_i  (MemStall_reg),
    .RegWrite_i  (EX_RegWrite),
	.RegWrite_o  (MEM_RegWrite),
    .MemtoReg_i  (EX_MemtoReg),
	.MemtoReg_o  (MEM_MemtoReg),
    .MemRead_i   (MemRead),
	.MemRead_o   (MEM_MemRead),
    .MemWrite_i  (EX_MemWrite),
	.MemWrite_o  (MEM_MemWrite),
    .ALUResult_i (ALUResult),
	.ALUResult_o (MEM_ALUResult),
    .RS2data_i   (EX_RS2data),
	.RS2data_o   (MEM_RS2data),
	.RDaddr_i    (RDaddr),
	.RDaddr_o    (MEM_RDaddr)
);


wire        WB_MemtoReg;
wire [31:0] MEM_MemData, WB_ALUResult, WB_MemData;
/* OK, OK */
MEM_WB MEM_WB(
    .clk_i       (clk_i),
    .start_i     (start_i),
    .MemStall_i  (MemStall_reg),
    .RegWrite_i  (MEM_RegWrite),
	.RegWrite_o  (WB_RegWrite),
	.MemtoReg_i  (MEM_MemtoReg),
	.MemtoReg_o  (WB_MemtoReg),
    .ALUResult_i (MEM_ALUResult),
	.ALUResult_o (WB_ALUResult),
    .MemData_i   (MEM_MemData),
	.MemData_o   (WB_MemData),
	.RDaddr_i    (MEM_RDaddr),
	.RDaddr_o    (WB_RDaddr)
);


// TODO: "MemStall" for PC and pipeline register
dcache_controller dcache
(
	.clk_i          (clk_i), 
	.rst_i          (rst_i),	
	.mem_data_i     (mem_data_i), 
	.mem_ack_i      (mem_ack_i), 	
	.mem_data_o     (mem_data_o), 
	.mem_addr_o     (mem_addr_o), 	
	.mem_enable_o   (mem_enable_o), 
	.mem_write_o    (mem_write_o),
	.cpu_data_i     (MEM_RS2data),
	.cpu_addr_i     (MEM_ALUResult),
	.cpu_MemRead_i  (MEM_MemRead),
	.cpu_MemWrite_i (MEM_MemWrite),
	.cpu_data_o     (MEM_MemData),   
	.cpu_stall_o    (MemStall)
);


/* OK, OK */
MUX32 MUX_MemtoReg(
    .data1_i    (WB_ALUResult),
    .data2_i    (WB_MemData),
    .select_i   (WB_MemtoReg),
    .data_o     (RDdata)
);


wire [1:0] ForwardA, ForwardB;
/* OK, OK */
Forward_Control Forward_Control(
    .EXRS1addr_i     (EX_RS1addr),
    .EXRS2addr_i     (EX_RS2addr),
    .ForwardA_o      (ForwardA),
	.ForwardB_o      (ForwardB),
    .MEM_RegWrite_i  (MEM_RegWrite),
	.WB_RegWrite_i   (WB_RegWrite),
    .MEM_RDaddr_i    (MEM_RDaddr),
	.WB_RDaddr_i     (WB_RDaddr)
);


/* OK, OK */
MUX32_4 MUX_RS1data(
    .data1_i    (MUX_EX_RS1data),
    .data2_i    (RDdata),
    .data3_i    (MEM_ALUResult),
    .data4_i    (32'b0), //unused
    .select_i   (ForwardA),
    .data_o     (ALU.data1_i)
);


/* OK, OK */
MUX32_4 MUX_RS2data(
    .data1_i    (MUX_EX_RS2data),
    .data2_i    (RDdata),
    .data3_i    (MEM_ALUResult),
    .data4_i    (32'b0), //unused
    .select_i   (ForwardB),
    .data_o     (EX_RS2data)
);


/* OK, OK */
Adder Add_PC(
    .data1_i   (instr_addr),
    .data2_i   (32'd4),
    .data_o    (MUX_PC_Branch.data1_i)
);


/* OK, OK */
Adder Add_PC_Branch(
    .data1_i   (extended_imm << 1),
    .data2_i   (IF_ID_PC_o),
    .data_o    (MUX_PC_Branch.data2_i)
);


/* OK, OK */
MUX32 MUX_PC_Branch(
    .data1_i    (Add_PC.data_o),
    .data2_i    (Add_PC_Branch.data_o),
    .select_i   (PC_select_reg), // need initial
    .data_o     (PC.pc_i)
);


/* OK, OK */
PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .stall_i    (MemStall_reg),
    .PCWrite_i  (PCWrite_reg),
    .pc_i       (MUX_PC_Branch.data_o),
    .pc_o       (instr_addr)
);


/* OK, OK */
Instruction_Memory Instruction_Memory(
    .addr_i     (instr_addr), 
    .instr_o    (IF_ID.instr_i)
);


/* OK, OK */
Registers Registers(
    .clk_i      (clk_i),
    .RS1addr_i  (instruction[19:15]),
    .RS2addr_i  (instruction[24:20]),
    .RDaddr_i   (WB_RDaddr), 
    .RDdata_i   (RDdata),
    .RegWrite_i (WB_RegWrite), 
    .RS1data_o  (RS1data), 
    .RS2data_o  (RS2data)
);


/* OK, OK */
MUX32 MUX_ALUSrc(
    .data1_i    (EX_RS2data),
    .data2_i    (EX_Imm),
    .select_i   (EX_ALUSrc),
    .data_o     (ALU.data2_i)
);


/* Imm Gen */
/* OK, OK */
Sign_Extend Sign_Extend(
    .data_i     (instruction),
    .data_o     (extended_imm)
);


/* OK, OK */
ALU ALU(
    .data1_i    (MUX_RS1data.data_o),
    .data2_i    (MUX_ALUSrc.data_o),
    .ALUCtrl_i  (ALU_Control.ALUCtrl_o),
    .data_o     (ALUResult)
);


/* OK, OK */
ALU_Control ALU_Control(
    .funct_i    (EX_funct),
    .ALUOp_i    (EX_ALUOp),
    .ALUCtrl_o  (ALU.ALUCtrl_i)
);


/* OK, OK */
Hazard_Detection Hazard_Detection(
    .RS1addr_i  (instruction[19:15]),
    .RS2addr_i  (instruction[24:20]),
    .MemRead_i  (MemRead),
    .RDaddr_i   (RDaddr),
    .stall_o    (Stall),
    .PCWrite_o  (PCWrite),
    .NoOp_o     (NoOp)
);

endmodule

