vlog -work work -sv -stats=none ../../program_counter.sv program_counter_testbench.sv
vsim -gui work.program_counter_testbench
restart -force
view wave
add wave sim:/program_counter_testbench/clk
add wave sim:/program_counter_testbench/current_vector
add wave sim:/program_counter_testbench/pc_output
add wave sim:/program_counter_testbench/dut/data
radix signal sim:/program_counter_testbench/dut/data hexadecimal
radix signal sim:/program_counter_testbench/current_vector hexadecimal
radix signal sim:/program_counter_testbench/current_vector.reset_n hexadecimal
radix signal sim:/program_counter_testbench/current_vector.enable_n hexadecimal
radix signal sim:/program_counter_testbench/current_vector.load_new_address hexadecimal
radix signal sim:/program_counter_testbench/current_vector.address_expected hexadecimal
radix signal sim:/program_counter_testbench/pc_output hexadecimal
radix signal sim:/program_counter_testbench/pc_output.address hexadecimal
radix signal sim:/program_counter_testbench/vector_num unsigned
radix signal sim:/program_counter_testbench/num_errors unsigned
run -all

