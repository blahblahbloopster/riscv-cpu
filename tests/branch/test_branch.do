vsim -gui work.branch_testbench
restart -force
view wave
add wave sim:/branch_testbench/clk
add wave -divider "Test Vector"
add wave -radix hexadecimal sim:/branch_testbench/current_vector
add wave -divider "Actual Outputs"
add wave -radix hexadecimal sim:/branch_testbench/branch_outputs
add wave -divider "Test Info"
add wave -radix hexadecimal sim:/branch_testbench/dut/offset
add wave -radix unsigned sim:/branch_testbench/vector_num
add wave -radix unsigned sim:/branch_testbench/num_errors
run -all

