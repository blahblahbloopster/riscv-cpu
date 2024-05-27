vsim -gui work.register_testbench
restart -force
view wave
add wave *
add wave sim:/register_testbench/dut/value
radix signal sim:/register_testbench/dut/value
radix signal sim:/register_testbench/data hexadecimal
radix signal sim:/register_testbench/store hexadecimal
radix signal sim:/register_testbench/enable_a hexadecimal
radix signal sim:/register_testbench/enable_b hexadecimal
radix signal sim:/register_testbench/a_out hexadecimal
radix signal sim:/register_testbench/b_out hexadecimal
radix signal sim:/register_testbench/a_out_expected hexadecimal
radix signal sim:/register_testbench/b_out_expected hexadecimal
radix signal sim:/register_testbench/current_vector hexadecimal
radix signal sim:/register_testbench/vector_num unsigned
radix signal sim:/register_testbench/num_errors unsigned
run -all

