module uart (
    input logic clock,reset,rx_bit,uart_wr_enable,uart_sel,
    input logic [31:0]wdata_mem,  //data to write
    input logic [3:0]uart_addr,  //address
    output logic tx_bit,
    output logic [31:0]uart_data //data to read
);

logic [7:0]tx_fifo_data,rx_fifo_data,tx_data,rx_data;
logic parity_enable,stop_bit,parity,tx_fifo_full,tx_parity_add,rx_parity_add,tx_shift_reg_en,rx_fifo_rd_en,parity_error,uart_en,tx_fifo_rd_en;
logic tx_fifo_wr_en,stop_bit_error,rx_fifo_empty,rx_fifo_full,busy,rx_en,tx_en,rx_baud_rate_reg_en,tx_fifo_empty,tx_baud_rate_reg_en;
logic bit_count,rx_baud_rate,tx_baud_rate,tx_shift_en,tx_bit_count_reg_en,rx_shift_reg_en,rx_bit_count_reg_en,tx_bit_count;
logic rx_bit_count,rx_fifo_wr_en,status_reg_en,receive_parity;
logic [15:0]baud_rate;

 bit_count_reg counter_reg(
  .*
);

 baud_rate_reg baud_reg(
    .*
);

parity_calculate parity_calculator(
    .*
);
assign parity_error =(receive_parity!=rx_parity_add);

fifo RX_FIFO (
    .clock(clock),
    .reset(reset),
    .fifo_rd_en(rx_fifo_rd_en),
    .fifo_wr_en(rx_fifo_wr_en),
    .fifo_data(rx_fifo_data),
    .fifo_empty(rx_fifo_empty),
    .fifo_full(rx_fifo_full),
    .fifo_data_out(rx_data)
);

rx_shift_reg r_shift_reg(
    .*
);

tx_shift_reg t_shift(
    .*
);

fifo TX_FIFO(
    .clock(clock),
    .reset(reset),
    .fifo_rd_en(tx_fifo_rd_en),
    .fifo_wr_en(tx_fifo_wr_en),
    .fifo_data(tx_fifo_data),
    .fifo_empty(tx_fifo_empty),
    .fifo_full(tx_fifo_full),
    .fifo_data_out(tx_data)
);

uart_controller uart_contr(
    .*
);

uart_registerfile uart_reg(
    .*
);

endmodule