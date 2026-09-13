module fifo #(parameter DEPTH =64)(
    input logic clock,reset,fifo_rd_en,fifo_wr_en,
    input logic [7:0]fifo_data,
    output logic  fifo_empty, fifo_full,
    output logic [7:0] fifo_data_out
);
  logic [7:0]fifo [DEPTH-1:0];
  logic [$clog2(DEPTH)-1:0] wptr,wptr_n,rptr,rptr_n,wptr_n_full;


//ram read and write
//write
always_ff @(posedge clock) begin
    if (fifo_wr_en && !fifo_full) begin
        fifo[wptr] <= fifo_data;
    end
end
//read
always_ff @(posedge clock) begin
    if (fifo_rd_en && !fifo_empty) begin
        fifo_data_out <= fifo[rptr];
    end
end

// pointer update
always_ff @(posedge clock or posedge reset) begin
    if (reset) begin
        wptr <= 0;
        rptr <= 0;
    end
    else begin
        wptr <= wptr_n;
        rptr <= rptr_n;
    end
end

// next pointer logic
always_comb begin
   if (fifo_wr_en && !fifo_full) begin
        wptr_n = wptr + 1;
    end
    else begin
        wptr_n = wptr;
    end
end
always_comb begin
    if (fifo_rd_en && !fifo_empty) begin
        rptr_n = rptr + 1;
    end
    else begin
        rptr_n = rptr;
    end
end

// full and empty logic
assign fifo_empty = (wptr == rptr);
assign wptr_n_full = wptr + 1;
assign fifo_full = (wptr_n_full == rptr);

endmodule