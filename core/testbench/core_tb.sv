module core_tb;

    // Signals
    logic clock;
    logic reset;
    logic tx_bit;
    logic rx_bit;

    // Instantiate the processor
    core dut (
        .*
    );

    // Clock generation
    initial begin
        clock = 0;
        forever #5 clock = ~clock; // Toggle clock every 5ns
    end

    // Test stimulus
    initial begin
        reset = 1;
        #10 reset = 0;  // De-assert reset after 10ns

        #300000;  // Run simulation for 100ns
        $finish; // End simulation
        $stop;
    end
always_comb begin 
    rx_bit=tx_bit;
end

endmodule
