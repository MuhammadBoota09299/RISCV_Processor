package packages;
    typedef enum logic [6:0] {
        R_TYPE = 7'b0110011,
        I_TYPE = 7'b0010011,
        STORE  = 7'b0100011,
        LOAD   = 7'b0000011,
        BRANCH = 7'b1100011,
        LUI    = 7'b0110111,
        AUIPC  = 7'b0010111,
        JAL    = 7'b1101111,
        JALR   = 7'b1100111
    } Opcodes;

    typedef enum logic [3:0] {
        ADD  = 4'b0000,
        SUB  = 4'b0001,
        SLL  = 4'b0010,
        SLT  = 4'b0100,
        SLTU = 4'b0110,
        XOR  = 4'b1000,
        SRL  = 4'b1010,
        SRA  = 4'b1011,
        OR   = 4'b1100,
        AND  = 4'b1110,
        PASS = 4'b0011
    } Alu_op;

    typedef enum logic [2:0] {
        BEQ  = 3'b000,
        BNE  = 3'b001,
        PC   = 3'b010,
        ALU  = 3'b011,
        BLT  = 3'b100,
        BGE  = 3'b101,
        BLTU = 3'b110,
        BGEU = 3'b111
    } Br_type;

    typedef enum logic [2:0] {
        BYTE               = 3'b000,
        HALF_WORD          = 3'b001,
        WORD               = 3'b010,
        UNSIGNED_BYTE      = 3'b100,
        UNSIGNED_HALF_WORD = 3'b101
    } load_store;


                                 /// UART Definitions ///


    // Base address (configurable)
    parameter UART_BASE_ADDRESS = 28'h1600000;
    // Register address mapping using enum
    typedef enum logic [3:0] {
        STATUS_REG = 4'h0,
        DATA_REG   = 4'h4,
        CTRL_REG   = 4'h8,
        BAUD_REG   = 4'hC
    } uart_reg_address_t;

    // -------------------- UART Control Register --------------------
    typedef struct packed {
        logic [1:0] reserved;      // Bits 7:6 - Reserved
        logic       rx_en;         // Bit 5: Receiver enable
        logic       tx_en;         // Bit 4: Transmitter enable
        logic       parity_enable; // Bit 3: Parity enable
        logic       parity;        // Bit 2: Parity type (0=even, 1=odd)
        logic       stop_bit;      // Bit 1: Stop bit (0=1-bit, 1=2-bit)
        logic       uart_en;       // Bit 0: UART enable
    } uart_ctrl_reg_t;
    
    // -------------------- UART Status Register --------------------
    typedef struct packed {
        logic rx_fifo_rd_en;   // Bit 7: FIFO read enable
        logic tx_fifo_wr_en;   // Bit 6: FIFO write enable
        logic rx_fifo_full;    // Bit 5: RX FIFO full
        logic tx_fifo_full;    // Bit 4: TX FIFO full
        logic rx_fifo_empty;   // Bit 3: RX FIFO empty
        logic parity_error;    // Bit 2: Parity error
        logic stop_bit_error;  // Bit 1: Stop bit error
        logic busy;            // Bit 0: UART busy
    } uart_status_reg_t;

    typedef struct packed {
        logic [15:0] baud_rate; // 16-bit baud rate value
    } uart_baud_reg_t;

    typedef struct packed {
        logic [7:0] data; // 8-bit data value
    } uart_data_reg_t;

    typedef struct packed {
        uart_status_reg_t status;
        uart_data_reg_t   data;
        uart_ctrl_reg_t   ctrl;
        uart_baud_reg_t   baud;
    } uart_registerfile_t;
endpackage
