vlog testbench/alu_reg_imm_tb.sv
vsim -gui work.alu_reg_imm_tb
restart -force
view wave
add wave *
radix signal sim:/alu_reg_imm_tb/vector hexadecimal
radix signal sim:/alu_reg_imm_tb/outputs hexadecimal
radix signal sim:/alu_reg_imm_tb/vector_num unsigned
radix signal sim:/alu_reg_imm_tb/num_errors unsigned
run -all

