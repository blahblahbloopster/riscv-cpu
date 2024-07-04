vsim -gui work.alu_testbench
restart -force
view wave
add wave *
radix signal sim:/alu_testbench/a hexadecimal
radix signal sim:/alu_testbench/b hexadecimal
radix signal sim:/alu_testbench/out hexadecimal
radix signal sim:/alu_testbench/out_expected hexadecimal
radix signal sim:/alu_testbench/current_vector hexadecimal
radix signal sim:/alu_testbench/vector_num unsigned
radix signal sim:/alu_testbench/num_errors unsigned
run -all

