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
logic [7:0] uart_data_reg,uart_ctrl_reg, uart_status_reg;
logic [15:0] uart_baud_rate_reg;




// Control register
assign rx_en     = uart_ctrl_reg[5];  // Bit 5 = receiver enable 
assign tx_en     = uart_ctrl_reg[4];  // Bit 4 = transmitter enable
assign parity_enable = uart_ctrl_reg[3];  // Bit 3 = parity enable
assign parity    = uart_ctrl_reg[2];  // Bit 2 = parity type (0=even, 1=odd)
assign stop_bit  = uart_ctrl_reg[1];  // Bit 1 = stop bit (0=1-bit, 1=2-bit)
assign uart_en   = uart_ctrl_reg[0];  // Bit 0 = UART enable

// Baud_rate register
assign baud_rate = uart_baud_rate_reg;

// Data register
assign tx_fifo_data = uart_data_reg;

always_ff @(negedge clock ) begin 
    if (reset) begin
        uart_data_reg<=8'b0;
        uart_baud_rate_reg<=16'b0;
        uart_ctrl_reg<=8'b0;
        tx_fifo_wr_en<=1'b0;
        uart_status_reg <=1'b0;
    end
    else if (uart_wr_enable) begin
        case (uart_addr)
            DATA_REG:begin
                uart_data_reg<=wdata_mem[7:0];
                tx_fifo_wr_en<=1'b1;
                $display("UART: Writing data 0x%0h to TX FIFO", wdata_mem[7:0]);
            end
            CTRL_REG:begin
                if (!busy) uart_ctrl_reg <=wdata_mem[7:0];
                tx_fifo_wr_en<=1'b0;
                $display("UART: Writing control data 0x%0h", wdata_mem[7:0]);
            end
            BAUD_REG:begin
                if (!(busy || uart_en)) uart_baud_rate_reg <=wdata_mem[15:0];
                tx_fifo_wr_en<=1'b0;
                $display("UART: Writing baud rate data 0x%0h", wdata_mem[15:0]);
            end
            default: tx_fifo_wr_en<=1'b0;
        endcase
    end
    else begin
        tx_fifo_wr_en<=1'b0;
    end

    // Status register
    if (status_reg_en ) begin
        uart_status_reg = {
        rx_fifo_rd_en,   // Bit 7: fifo rd_en
        tx_fifo_wr_en,   // Bit 6: fifo wr_en
        rx_fifo_full,    // Bit 5: RX FIFO full
        tx_fifo_full,    // Bit 4: TX FIFO full
        rx_fifo_empty,   // Bit 3: RX FIFO empty
        parity_error,    // Bit 2: Parity error
        stop_bit_error,  // Bit 1: Stop bit error
        busy             // Bit 0: UART busy
    };
    end
end
always_comb begin 
    case (uart_addr)
    STATUS_REG :begin
        uart_data={28'b0,uart_status_reg};
        rx_fifo_rd_en=1'b0;
        $display("UART: Reading status register 0x%0h", uart_status_reg);
    end
    DATA_REG   :begin
        uart_data={28'b0,rx_data};
        if (uart_sel) rx_fifo_rd_en=1'b1;
        $display("UART: Reading data register 0x%0h", rx_data);
    end
    CTRL_REG   :begin
        uart_data={28'b0,uart_ctrl_reg};
        rx_fifo_rd_en=1'b0;
        $display("UART: Reading control register 0x%0h", uart_ctrl_reg);
    end
    BAUD_REG   :begin
        uart_data={28'b0,uart_baud_rate_reg};
        rx_fifo_rd_en=1'b0;
        $display("UART: Reading baud rate register 0x%0h", uart_baud_rate_reg);
    end
        default: rx_fifo_rd_en=1'b0;
    endcase
end
endmodule