vlog -work work -sv -stats=none ../../register.sv ../../register_array.sv register_array_testbench.sv
vsim -gui work.register_array_testbench
restart -force
view wave
add wave sim:/register_array_testbench/clk
add wave sim:/register_array_testbench/current_vector
add wave sim:/register_array_testbench/register_array_output
add wave sim:/register_array_testbench/dut/store_decoded
add wave sim:/register_array_testbench/dut/enable_a_decoded
add wave sim:/register_array_testbench/dut/enable_b_decoded
add wave sim:/register_array_testbench/dut/R1/value
# add wave sim:/register_array_testbench/dut/R2/value
radix signal sim:/register_array_testbench/current_vector hexadecimal
radix signal sim:/register_array_testbench/current_vector.reset_n hexadecimal
radix signal sim:/register_array_testbench/current_vector.store hexadecimal
radix signal sim:/register_array_testbench/current_vector.enable_a hexadecimal
radix signal sim:/register_array_testbench/current_vector.enable_b hexadecimal
radix signal sim:/register_array_testbench/current_vector.store_value hexadecimal
radix signal sim:/register_array_testbench/current_vector.a_bus_expected hexadecimal
radix signal sim:/register_array_testbench/current_vector.b_bus_expected hexadecimal
radix signal sim:/register_array_testbench/register_array_output hexadecimal
radix signal sim:/register_array_testbench/register_array_output.a_bus hexadecimal
radix signal sim:/register_array_testbench/register_array_output.b_bus hexadecimal
radix signal sim:/register_array_testbench/dut/store_decoded hexadecimal
radix signal sim:/register_array_testbench/dut/enable_a_decoded hexadecimal
radix signal sim:/register_array_testbench/dut/enable_b_decoded hexadecimal
radix signal sim:/register_array_testbench/vector_num unsigned
radix signal sim:/register_array_testbench/num_errors unsigned
run -all

