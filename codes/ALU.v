`include "constants.vh"

module ALU
(
    data1_i,
    data2_i,
    ALUCtrl_i,
    data_o,
);

// Ports
input signed [31:0]   data1_i, data2_i;
input   [3:0]    ALUCtrl_i; // 4 bits now
output signed [31:0]  data_o;
reg     [31:0]   data_o;

always @(data1_i or data2_i or ALUCtrl_i) begin
    case(ALUCtrl_i)
        `ADD_ALUCtrl:  data_o = data1_i + data2_i;
        `SUB_ALUCtrl:  data_o = data1_i - data2_i;
        `AND_ALUCtrl:  data_o = data1_i & data2_i;
        `XOR_ALUCtrl:  data_o = data1_i ^ data2_i;
        `SLL_ALUCtrl:  data_o = data1_i << data2_i;
        `MUL_ALUCtrl:  data_o = data1_i * data2_i;
        `SRAI_ALUCtrl: data_o = data1_i >>> data2_i;
    endcase

end


endmodule