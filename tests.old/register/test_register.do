vlog -work work -sv -stats=none ../../register.sv register_testbench.sv
vsim -gui work.register_testbench
restart -force
view wave
add wave sim:/register_testbench/clk
add wave sim:/register_testbench/current_vector
add wave sim:/register_testbench/register_output
add wave sim:/register_testbench/dut/data
radix signal sim:/register_testbench/dut/data hexadecimal
radix signal sim:/register_testbench/current_vector hexadecimal
radix signal sim:/register_testbench/current_vector.reset_n hexadecimal
radix signal sim:/register_testbench/current_vector.store hexadecimal
radix signal sim:/register_testbench/current_vector.enable_a hexadecimal
radix signal sim:/register_testbench/current_vector.enable_b hexadecimal
radix signal sim:/register_testbench/current_vector.a_out_expected hexadecimal
radix signal sim:/register_testbench/current_vector.b_out_expected hexadecimal
radix signal sim:/register_testbench/register_output hexadecimal
radix signal sim:/register_testbench/register_output.a_out hexadecimal
radix signal sim:/register_testbench/register_output.b_out hexadecimal
radix signal sim:/register_testbench/vector_num unsigned
radix signal sim:/register_testbench/num_errors unsigned
run -all

