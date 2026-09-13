import packages::*;
module decoder (
    input logic [31:0]instruction,instruction_mem,
    output logic reg_wr,sel_B,mem_wr,sel_A,stall,forward_sel_1,forward_sel_2,
    output logic [1:0]wb_sel,
    output logic [2:0]rd_wr_mem,br_type,
    output logic [31:0]immediate,
    output logic [3:0]alu_op
);
logic [2:0]funct3;
logic [6:0]opcode;
logic [4:0]waddr_mem,raddr1_decode,raddr2_decode;
always_comb begin 
opcode = instruction[6:0];
funct3=instruction[14:12];
rd_wr_mem=funct3;
stall=1'b0;
    case (opcode)
        R_TYPE:begin
            alu_op={funct3,instruction[30]};
            reg_wr=1'b1;
            sel_B=1'b0;
            sel_A=1'b0;
            mem_wr=1'b0;
            wb_sel=2'b0;
            br_type=PC;
        end 
        I_TYPE , LOAD:begin
            alu_op=ADD;
            reg_wr=1'b1;
            immediate = { {20{instruction[31]}}, instruction[31:20] };
            sel_B=1'b1;
            sel_A=1'b0;
            wb_sel = (opcode == LOAD) ? 2'b1 : 2'b0;
            mem_wr=1'b0;
            br_type=PC;
        end
        STORE:begin
            alu_op=ADD;
            reg_wr=1'b0;
            mem_wr=1'b1;
            sel_B=1'b1;
            sel_A=1'b0;
            immediate={{20{instruction[31]}},instruction[31:25], instruction[11:7]};
            br_type=PC;
        end
        BRANCH:begin
            br_type=funct3;
            alu_op=ADD;
            reg_wr=1'b0;
            sel_A=1'b1;
            sel_B=1'b1;
            mem_wr=1'b0;
            immediate={{19{instruction[31]}},instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0};
        end
        LUI , AUIPC :begin
            alu_op=(opcode==LUI) ? PASS: ADD;
            reg_wr=1'b1;
            sel_A =1'b1;
            sel_B =1'b1;
            br_type=PC;
            wb_sel =2'b0;
            immediate={instruction[31:12], 12'b0};
            mem_wr=1'b0;
        end
        JAL,JALR:begin
            alu_op=ADD;
            reg_wr=1'b1;
            sel_A=(opcode==JAL) ? 1'b1:1'b0;
            sel_B=1'b1;
            br_type=ALU;
            wb_sel=2'b10;
            mem_wr=1'b0;
            stall=1'b1;
            immediate=(opcode==JAL) ? {{19{instruction[31]}},instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0} :{ {20{instruction[31]}}, instruction[31:20] };
        end
        default:begin
            alu_op=4'b0;
            reg_wr=1'b0;
            immediate =32'b0;
            sel_B=1'b0;
            sel_A=1'b0;
            wb_sel=1'b0;
            mem_wr=1'b0;
            br_type=PC;
            end 
    endcase      
end 
always_comb begin
    forward_sel_1=1'b0;
    forward_sel_2=1'b0;
    waddr_mem=instruction_mem[11:7];
    raddr1_decode=instruction[19:15];
    raddr2_decode=instruction[24:20];
    case (waddr_mem)
        raddr1_decode:forward_sel_1=1'b1;
        raddr2_decode:forward_sel_2=1'b1;
        default:begin
            forward_sel_1=1'b0;
            forward_sel_2=1'b0;
        end
    endcase
end
endmodule
