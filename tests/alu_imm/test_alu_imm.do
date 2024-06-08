vsim -gui work.alu_testbench
restart -force
view wave
add wave *
radix signal sim:/alu_imm_testbench/current_vector hexadecimal
radix signal sim:/alu_imm_testbench/alu_imm_outputs hexadecimal
radix signal sim:/alu_imm_testbench/vector_num unsigned
radix signal sim:/alu_imm_testbench/num_errors unsigned
run -all

