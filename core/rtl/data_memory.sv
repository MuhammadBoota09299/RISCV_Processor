import packages::*;
module data_memory #(SIZE=512) (
    input logic [3:0] [7:0] wdata_mem,
    input logic [9:0] addr_mem,
    input logic [2:0] rd_wr_mem,
    input logic mem_wr,clock,reset,
    output logic [3:0] [7:0] rdata_mem
);
logic [3:0] [7:0] memory[SIZE-1:0];
logic [3:0] [7:0] word;
always_comb begin 
    if (mem_wr) begin
        case (rd_wr_mem)
            BYTE               : word = {rdata_mem[3:1], wdata_mem[0]};
            HALF_WORD          : word = {rdata_mem[3:2], wdata_mem[1:0]};
            WORD               : word =  wdata_mem;
            default            : word =  wdata_mem;    
        endcase
    end
    
end
    always_ff @( clock ) begin 
            memory[addr_mem] <= word;
    end
    always_comb begin 
        case (rd_wr_mem)
            BYTE               : rdata_mem = {{24{memory[addr_mem][0][7]}}, memory[addr_mem][0]};
            HALF_WORD          : rdata_mem = {{16{memory[addr_mem][1][7]}},memory[addr_mem][1:0]};
            WORD               : rdata_mem =  memory[addr_mem][3:0];
            UNSIGNED_BYTE      : rdata_mem = {24'b0,memory[addr_mem][0]};
            UNSIGNED_HALF_WORD : rdata_mem = {16'b0,memory[addr_mem][1],memory[addr_mem][1:0]};
            default            : rdata_mem = memory[addr_mem][3:0];
        endcase
    end
endmodule