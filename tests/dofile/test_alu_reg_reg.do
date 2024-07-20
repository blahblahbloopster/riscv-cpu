vlog testbench/alu_reg_reg_tb.sv
vsim -gui work.alu_reg_reg_tb
restart -force -nolog
view wave
add wave sim:/alu_reg_reg_tb/clk
add wave -radix hexadecimal sim:/alu_reg_reg_tb/vector
add wave -radix hexadecimal sim:/alu_reg_reg_tb/outputs
add wave -radix unsigned sim:/alu_reg_reg_tb/vector_num
add wave -radix unsigned sim:/alu_reg_reg_tb/num_errors
run -all

