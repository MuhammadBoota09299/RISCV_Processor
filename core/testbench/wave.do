add wave -group "Testbench" sim:/core_tb/*
add wave -group "FETCH TO DECODE" sim:/core_tb/dut/fetch_to_decode_reg/*
add wave -group "EXECUTE TO MEMORY" sim:/core_tb/dut/execute_to_memory_reg/*
add wave -group "UART" sim:/core_tb/dut/UART/*

run -all