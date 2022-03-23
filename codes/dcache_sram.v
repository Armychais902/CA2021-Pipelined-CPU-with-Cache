module dcache_sram
(
    clk_i,
    rst_i,
    addr_i,
    tag_i,
    data_i,
    enable_i,
    write_i,
    tag_o,
    data_o,
    hit_o
);

// I/O Interface from/to controller
input              clk_i;
input              rst_i;
input    [3:0]     addr_i;
input    [24:0]    tag_i;
input    [255:0]   data_i;
input              enable_i;
input              write_i;

output   [24:0]    tag_o;
output   [255:0]   data_o;
output             hit_o;


// Memory
reg      [24:0]    tag [0:15][0:1];    
reg      [255:0]   data[0:15][0:1];

integer            i, j;

reg                record[0:15];

// !!! Discuss with b08902056 about how to implement the LRU policy correctly !!!

// Write Data      
// 1. Write hit
// 2. Read miss: Read from memory
always@(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        for (i=0;i<16;i=i+1) begin
            record[i] <= 1'b0;
            for (j=0;j<2;j=j+1) begin
                tag[i][j] <= 25'b0;
                data[i][j] <= 256'b0;
            end
        end
    end
    if (enable_i && write_i) begin
        // TODO: Handle your write of 2-way associative cache + LRU here
        if((tag[addr_i][0][22:0] == tag_i[22:0]) && tag[addr_i][0][24]) begin
            // write hit, to 0, 1 old
            data[addr_i][0] <= data_i;
            tag[addr_i][0] <= tag_i;
            record[addr_i] <= 1'b1;
        end
        else if((tag[addr_i][1][22:0] == tag_i[22:0]) && tag[addr_i][1][24])    begin
            // write hit, to 1, 0 old
            data[addr_i][1] <= data_i;
            tag[addr_i][1] <= tag_i;
            record[addr_i] <= 1'b0;
        end
        else begin
            // read miss, replace the old and flip bit
            data[addr_i][record[addr_i]] <= data_i;
            tag[addr_i][record[addr_i]] <= tag_i;
            record[addr_i] = ~(record[addr_i]);
        end
    end
    else if (enable_i)  begin   // not for write
        // read hit, switch the old and new
        if ((tag[addr_i][0][22:0] == tag_i[22:0]) && tag[addr_i][0][24]) begin
            record[addr_i] = 1'b1;
        end
        else if ((tag[addr_i][1][22:0] == tag_i[22:0]) && tag[addr_i][1][24]) begin
            record[addr_i] = 1'b0;
        end 
    end
end

// Read Data      
// TODO: tag_o=? data_o=? hit_o=?
// !!! important! for those don't match at all, controller need to decide whether to write back!!!
// so pass the old tag to controller
assign tag_o = ((tag[addr_i][0][22:0] == tag_i[22:0]) && tag[addr_i][0][24]) ? tag[addr_i][0] :
               ((tag[addr_i][1][22:0] == tag_i[22:0]) && tag[addr_i][1][24]) ? tag[addr_i][1] :
                                                                            tag[addr_i][record[addr_i]];

assign data_o = ((tag[addr_i][0][22:0] == tag_i[22:0]) && tag[addr_i][0][24]) ? data[addr_i][0] :
                ((tag[addr_i][1][22:0] == tag_i[22:0]) && tag[addr_i][1][24]) ? data[addr_i][1] :
                                                                            data[addr_i][record[addr_i]];

assign hit_o = (((tag[addr_i][0][22:0] == tag_i[22:0]) && tag[addr_i][0][24])
                || ((tag[addr_i][1][22:0] == tag_i[22:0]) && tag[addr_i][1][24]))
                ? 1'b1 : 1'b0;

endmodule
