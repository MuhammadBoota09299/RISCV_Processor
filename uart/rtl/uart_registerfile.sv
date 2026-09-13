import packages ::*;
module uart_registerfile (
    // signals from and to processor
    input logic clock,reset,uart_wr_enable,uart_sel,
    input logic [31:0]wdata_mem,  //data to write
    input logic [3:0]uart_addr,  //address
    output logic [31:0]uart_data, //data to read

    //signals from uart
    input logic tx_fifo_full,parity_error,stop_bit_error,status_reg_en,rx_fifo_full,rx_fifo_empty,busy, //to uart status register
    output logic  rx_fifo_rd_en, tx_fifo_wr_en, //from uart status register

    input logic [7:0]rx_data, //to data register
    output logic [7:0] tx_fifo_data, //from data register

    output logic parity_enable,parity,stop_bit,uart_en,tx_en,rx_en,  //from uart CTRL register
    
    output logic [15:0]baud_rate  // from uart baud register
);

// uart registers
uart_registerfile_t uart_registerfile,uart_registerfile_next;

// Control register
assign rx_en     = uart_registerfile.ctrl.rx_en;  // Bit 5 = receiver enable 
assign tx_en     = uart_registerfile.ctrl.tx_en;  // Bit 4 = transmitter enable
assign parity_enable = uart_registerfile.ctrl.parity_enable;  // Bit 3 = parity enable
assign parity    = uart_registerfile.ctrl.parity;  // Bit 2 = parity type (0=even, 1=odd)
assign stop_bit  = uart_registerfile.ctrl.stop_bit;  // Bit 1 = stop bit (0=1-bit, 1=2-bit)
assign uart_en   = uart_registerfile.ctrl.uart_en;  // Bit 0 = UART enable

// Baud_rate register
assign baud_rate = uart_registerfile.baud;

// Data register
assign tx_fifo_data = uart_registerfile.data;

always_comb begin 
    tx_fifo_wr_en          = 1'b0;
    uart_registerfile_next = uart_registerfile; // Default assignment to hold current state
    if (uart_wr_enable) begin
        case (uart_addr)
            DATA_REG:begin
                uart_registerfile_next.data = wdata_mem[7:0];
                tx_fifo_wr_en =1'b1;
                $display("UART: Writing data 0x%0h to TX FIFO", wdata_mem[7:0]);
            end
            CTRL_REG:begin
                if (!busy) uart_registerfile_next.ctrl = wdata_mem[7:0];
                tx_fifo_wr_en = 1'b0;
                $display("UART: Writing control data 0x%0h", wdata_mem[7:0]);
            end
            BAUD_REG:begin
                if (!(busy || uart_en)) uart_registerfile_next.baud = wdata_mem[15:0];
                tx_fifo_wr_en = 1'b0;
                $display("UART: Writing baud rate data 0x%0h", wdata_mem[15:0]);
            end
            default: tx_fifo_wr_en = 1'b0;
        endcase
    end
    // Status register
    if (status_reg_en ) begin
        uart_registerfile_next.status = '{
            rx_fifo_rd_en:  rx_fifo_rd_en,
            tx_fifo_wr_en:  tx_fifo_wr_en,
            rx_fifo_full:   rx_fifo_full,
            tx_fifo_full:   tx_fifo_full,
            rx_fifo_empty:  rx_fifo_empty,
            parity_error:   parity_error,
            stop_bit_error: stop_bit_error,
            busy:           busy
        };
    end
end

always_ff @( posedge clock ) begin : blockName
    if (reset) begin
        uart_registerfile<= 'b0;
    end
    else begin
        uart_registerfile<=uart_registerfile_next;
    end
end

always_comb begin 
    case (uart_addr)
    STATUS_REG :begin
        uart_data={28'b0,uart_registerfile.status};
        rx_fifo_rd_en=1'b0;
    end
    DATA_REG   :begin
        uart_data={28'b0,rx_data};
        if (uart_sel) rx_fifo_rd_en=1'b1;
    end
    CTRL_REG   :begin
        uart_data={28'b0,uart_registerfile.ctrl};
        rx_fifo_rd_en=1'b0;
    end
    BAUD_REG   :begin
        uart_data={28'b0,uart_registerfile.baud};
        rx_fifo_rd_en=1'b0;
    end
        default: rx_fifo_rd_en=1'b0;
    endcase
end
endmodule