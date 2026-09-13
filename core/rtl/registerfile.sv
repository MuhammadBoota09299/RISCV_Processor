module registerfile (
    input logic [4:0]raddr1,raddr2,waddr,
    input logic [31:0]wdata,
    input logic reg_wr,clock,reset,
    output logic [31:0]rdata1,rdata2
);
    logic [31:0]register_file [31:0];
    logic [31:0]data;

    always_comb begin 
        if (reg_wr && (waddr > 5'b0)) begin
            data = wdata;
        end
        else begin
            data = register_file[waddr];
        end
    end
    always_ff @( negedge clock ) begin 
        if (reset)begin
            register_file[0]<=32'b0;
            register_file[1]<=32'b0;
            register_file[2]<=32'b0;
            register_file[3]<=32'b0;
            register_file[4]<=32'b0;
            register_file[5]<=32'b0;
            register_file[6]<=32'b0;
            register_file[7]<=32'b0;
            register_file[8]<=32'b0;
            register_file[9]<=32'b0;
            register_file[10]<=32'b0;
            register_file[11]<=32'b0;
            register_file[12]<=32'b0;
            register_file[13]<=32'b0;
            register_file[14]<=32'b0;
            register_file[15]<=32'b0;
            register_file[16]<=32'b0;
            register_file[17]<=32'b0;
            register_file[18]<=32'b0;
            register_file[19]<=32'b0;
            register_file[20]<=32'b0;
            register_file[21]<=32'b0;
            register_file[22]<=32'b0;
            register_file[23]<=32'b0;
            register_file[24]<=32'b0;
            register_file[25]<=32'b0;
            register_file[26]<=32'b0;
            register_file[27]<=32'b0;
            register_file[28]<=32'b0;
            register_file[29]<=32'b0;
            register_file[30]<=32'b0;
            register_file[31]<=32'b0;
        end
        else begin
            register_file[waddr]<=data;
        end
    end
    always_comb begin 
        rdata1=register_file[raddr1];
        rdata2=register_file[raddr2];
    end

endmodule
