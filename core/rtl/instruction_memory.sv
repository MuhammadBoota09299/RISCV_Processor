module instruction_memory (
    input logic clock,
    input logic [31:0]addr,
    output logic [31:0]inst
);
    logic [31:0]inst_memory [255:0];
    always_ff @( clock ) begin : instruction_memory
        inst=inst_memory[addr[31:2]];
    end
    
    initial begin
    $readmemh("../../assembly/c_commands/build/main.txt",inst_memory);
    //$readmemh("/home/aziz/Documents/Computer_Architecture_Lab/assembly/riscv_commands/build//gcd.txt",inst_memory);
    end
endmodule
