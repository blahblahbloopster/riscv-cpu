vlog -work work -sv -stats=none ../../program_counter.sv program_counter_testbench.sv
vsim -gui work.program_counter_testbench
restart -force
view wave
add wave sim:/program_counter_testbench/clk
add wave -divider "Test Vector"
add wave sim:/program_counter_testbench/current_vector
add wave -divider "Actual Output"
add wave sim:/program_counter_testbench/pc_output.address
add wave -divider "Test Info"
add wave sim:/program_counter_testbench/vector_num
add wave sim:/program_counter_testbench/num_errors
radix signal sim:/program_counter_testbench/current_vector hexadecimal
radix signal sim:/program_counter_testbench/current_vector.new_address hexadecimal
radix signal sim:/program_counter_testbench/current_vector.address_expected hexadecimal
radix signal sim:/program_counter_testbench/pc_output hexadecimal
radix signal sim:/program_counter_testbench/pc_output.address hexadecimal
radix signal sim:/program_counter_testbench/vector_num unsigned
radix signal sim:/program_counter_testbench/num_errors unsigned
run -all

