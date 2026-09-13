module core (
    input logic reset,clock,rx_bit,
    output logic tx_bit
);
logic [31:0]inst,instruction,instruction_mem,pc,pc_execute,pc_next,pc_mem,pc_next_mem,result,rdata1,data1,data2,rdata2,rs1,rs2,immediate,rdata_mem,wdata_mem,reg_data,pc_in,alu_mem,data,uart_data;
logic [3:0]alu_op,uart_addr;
logic [2:0]rd_wr_mem,rd_wr_mem_mem,br_type;
logic [1:0]wb_sel,wb_sel_mem;
logic reg_wr,reg_wr_mem,sel_B,sel_A,mem_wr,mem_wr_mem,br_taken,stall,forward_sel_1,forward_sel_2,uart_sel,uart_wr_enable,mem_wr_en;

//-----------fetch phase----------------

//pc  
pc _pc(.clock,.reset,.pc_in,.pc);
pc_add pc_4_add(.pc,.pc_next);
// PC or ALU slector mux
mux2_1 PC_ALU_sel(.sel(br_taken),.input0(pc_next),.input1(result),.out(pc_in));
//instruction memory
instruction_memory _instruction_memory(.addr(pc),.inst,.clock);
//pipeline register
pipline_fetch_to_decode fetch_to_decode_reg(.clock,.reset,.pc_fetch(pc),.instruction_fetch(inst),.stall,.br_taken,
.pc_execute,.instruction_execute(instruction));


//--------------decode and execute phase-------------

//registerfile
registerfile _registerfile(.raddr1(instruction[19:15]),.raddr2(instruction[24:20]),
.waddr(instruction_mem[11:7]),.wdata(reg_data),.reg_wr(reg_wr_mem),.rdata1,.rdata2,.clock,.reset);
//decoder
decoder _decoder(.instruction,.reg_wr,.alu_op,.immediate,.sel_B,.sel_A,.mem_wr,.wb_sel,.rd_wr_mem,.br_type,.stall,.instruction_mem,.forward_sel_1,.forward_sel_2);
//for forwarding muxes
mux2_1 forward_radda1(.input0(rdata1),.input1(reg_data),.out(data1),.sel(forward_sel_1));
mux2_1 forward_radda2(.input0(rdata2),.input1(reg_data),.out(data2),.sel(forward_sel_2));

//sel_A mux for rs1 or pc
mux2_1 Sel_A(.input0(data1),.input1(pc_execute),.out(rs1),.sel(sel_A));
//sel_B mux for rs2 or immediate
mux2_1 Sel_B(.input0(data2),.input1(immediate),.out(rs2),.sel(sel_B));
//Alu
alu _alu(.rs1,.rs2,.result,.alu_op);
//branch condition check
branch branch_condition(.rdata1(data1),.rdata2(data2),.br_type,.br_taken);


//---------------memory and writeback phase---------------

//pipline registor
pipline_execute_to_memory execute_to_memory_reg(.clock,.reset,.pc_execute,.alu_execute(result),.mem_wdata_execute(data2),
.instruction_execute(instruction),.reg_wr_execute(reg_wr),.mem_wr_execute(mem_wr),.rd_wr_mem_execute(rd_wr_mem),.wb_sel_execute(wb_sel),
.pc_mem, .alu_mem,.mem_wdata_mem(wdata_mem),.instruction_mem,.mem_wr_mem, .rd_wr_mem_mem,.reg_wr_mem,.wb_sel_mem);
//add 4 in pc of memory phase
pc_add pc_mem_4_add(.pc(pc_mem),.pc_next(pc_next_mem));

//lsu unit
lsu LSU(.*);

//uart
uart UART(.*);

//data memory
data_memory Data_memory(.clock,.reset,.addr_mem(alu_mem),.wdata_mem,.rdata_mem,.mem_wr(mem_wr_en),.rd_wr_mem(rd_wr_mem_mem));

//select uart or memory data mux
mux2_1 UART_MEM_MUX(.input0(rdata_mem),.input1(uart_data),.out(data),.sel(uart_sel));
//writeback mux
mux3_1 writeback_mux(.input0(alu_mem),.input1(data),.input2(pc_next_mem),.out(reg_data),.sel(wb_sel_mem));

endmodule
