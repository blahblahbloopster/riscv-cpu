/*
 * Adapted from Harris & Harris Digital Design and Computer Achitecture
 * Example 4.39 HDL Testbench with Test Vector File p 223
 */

module alu_testbench();

    logic clk;
    logic [3:0] op;
    logic [31:0] a, b, out, out_expected;
    logic [99:0] current_vector;
    logic [31:0] vector_num, num_errors;
    logic [99:0] test_vectors[1000:0];

    alu dut(op, a, b, out);

    always begin
        clk = 1;
        #5;
        clk = 0;
        #5;
    end

    initial begin
        $readmemh("alu_tests.tv", test_vectors);
        vector_num = 32'b0;
        num_errors = 32'b0;
        current_vector = test_vectors[vector_num];
    end

    always @(posedge clk) begin
        #1;
        {op, a, b, out_expected} = current_vector;
    end

    always @(negedge clk) begin
        if (out !== out_expected) begin
            $display("Compare error:");
            $display("op = %b", op);
            $display("a = %h", a);
            $display("b = %h", b);
            $display("out = %h (%h expected)", out, out_expected);
            num_errors = num_errors + 1;
        end

        vector_num = vector_num + 1;
        current_vector = test_vectors[vector_num];

        if (current_vector === 100'bx) begin
            $display("%d tests completed with %d errors",
                     vector_num, num_errors);
            $finish;
        end
    end

endmodule

