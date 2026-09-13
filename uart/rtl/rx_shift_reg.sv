module rx_shift_reg (
    input logic clock,reset,rx_bit,rx_shift_reg_en,
    output logic [7:0] rx_fifo_data
);
logic [8:0] rx_shift_reg,shift_reg_next;
assign rx_fifo_data=rx_shift_reg[7:0];

always_comb begin 
    if (rx_shift_reg_en) begin
        shift_reg_next = {rx_bit, rx_shift_reg[8:1]};
    end else begin
        shift_reg_next = rx_shift_reg;
    end
end

always_ff @( posedge clock ) begin 
    if (reset)begin
        rx_shift_reg<=9'b0;
    end else begin
        rx_shift_reg<=shift_reg_next;
    end
end
endmodule