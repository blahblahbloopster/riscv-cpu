vlog testbench/alu_reg_imm_tb.sv
vsim -gui work.alu_reg_imm_tb
restart -force -nolog
view wave
add wave sim:/alu_reg_imm_tb/clk
add wave -radix hexadecimal sim:/alu_reg_imm_tb/vector
add wave -radix hexadecimal sim:/alu_reg_imm_tb/outputs
add wave -radix unsigned sim:/alu_reg_imm_tb/vector_num
add wave -radix unsigned sim:/alu_reg_imm_tb/num_errors
run -all

