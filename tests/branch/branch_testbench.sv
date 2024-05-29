/*
 * Adapted from Harris & Harris Digital Design and Computer Achitecture
 * Example 4.39 HDL Testbench with Test Vector File p 223
 */

module alu_testbench();

    logic clk;
    logic [31:0] register_source_1;
    logic [31:0] register_source_2;
    logic [31:0] program_counter;
    logic [31:0] offset;
    logic [3:0] opcode;
    logic [3:0] enable_n;
    logic [31:0] new_program_counter;
    logic [31:0] new_program_counter_expected;
    logic [167:0] current_vector;
    logic [31:0] vector_num, num_errors;
    logic [99:0] test_vectors[1000:0];

    branch dut(clk, register_source_1, register_source_2, program_counter, offset, opcode[2:0], enable_n[0], new_program_counter);

    always begin
        clk = 1;
        #5;
        clk = 0;
        #5;
    end

    initial begin
        $readmemh("branch_tests.tv", test_vectors);
        vector_num = 32'b0;
        num_errors = 32'b0;
        current_vector = test_vectors[vector_num];
    end

    always @(posedge clk) begin
        #1;
        {clk, register_source_1, register_source_2, program_counter, offset,
                opcode[2:0], enable_n[0], new_program_counter,
                new_program_counter_expected
        } = current_vector;
    end

    always @(negedge clk) begin
        if (new_program_counter !== new_program_counter_expected) begin
            $display("Compare error:");
            $display("reg1 = %b", register_source_1);
            $display("reg2 = %b", register_source_2);
            $display("prog_counter = %h", program_counter);
            $display("offset = %h", offset);
            $display("opcode = %h", opcode[2:0]);
            $display("enable_n = %h", enable_n[0]);
            $display("new_prog_counter = %h (%h expected)", new_program_counter, new_program_counter_expected);
            num_errors = num_errors + 1;
        end

        vector_num = vector_num + 1;
        current_vector = test_vectors[vector_num];

        if (current_vector === 100'bx) begin
            $display("%d tests completed with %d errors",
                     vector_num, num_errors);
            $stop;
        end
    end

endmodule

