vsim -gui work.branch_testbench
restart -force
view wave
add wave *
radix signal sim:/branch_testbench/clk hexadecimal
radix signal sim:/branch_testbench/register_source_1 hexadecimal
radix signal sim:/branch_testbench/register_source_2 hexadecimal
radix signal sim:/branch_testbench/program_counter hexadecimal
radix signal sim:/branch_testbench/offset hexadecimal
radix signal sim:/branch_testbench/opcode hexadecimal
radix signal sim:/branch_testbench/enable_n hexadecimal
radix signal sim:/branch_testbench/new_program_counter hexadecimal
radix signal sim:/branch_testbench/new_program_counter_expected hexadecimal

radix signal sim:/branch_testbench/current_vector hexadecimal
radix signal sim:/branch_testbench/vector_num unsigned
radix signal sim:/branch_testbench/num_errors unsigned
run -all

