vlog testbench/alu_reg_reg_tb.sv
vsim -gui work.alu_reg_reg_tb
restart -force
view wave
add wave *
radix signal sim:/alu_reg_reg_tb/vector hexadecimal
radix signal sim:/alu_reg_reg_tb/outputs hexadecimal
radix signal sim:/alu_reg_reg_tb/vector_num unsigned
radix signal sim:/alu_reg_reg_tb/num_errors unsigned
run -all

