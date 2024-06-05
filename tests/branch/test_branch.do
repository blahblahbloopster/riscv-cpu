vsim -gui work.branch_testbench
restart -force
view wave
add wave -radix hexadecimal sim:/branch_testbench/current_vector
add wave -radix hexadecimal sim:/branch_testbench/branch_output
run -all

