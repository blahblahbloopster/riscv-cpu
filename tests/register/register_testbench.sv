/*
 * Adapted from Harris & Harris Digital Design and Computer Achitecture
 * Example 4.39 HDL Testbench with Test Vector File p 223
 */

`define TEST_VECTOR_FILE "alu_tests.tv"
`define VECTOR_SIZE 112
`define XLEN 32

module register_testbench();

    typedef struct packed {
        logic             reset_n;
        logic             store;
        logic             enable_a;
        logic             enable_b;
        logic [`XLEN-1:0] store_value;
        logic [`XLEN-1:0] a_out_expected;
        logic [`XLEN-1:0] b_out_expected;
    } TestVector;

    typedef struct packed {
        logic [`XLEN-1:0] a_out;
        logic [`XLEN-1:0] b_out;
    } RegisterOutput;

    logic clk;

    integer vector_file, i, c;
    reg [511:0] line;

    RegisterOutput register_output;
    TestVector current_vector;
    TestVector test_vectors [511:0];
    integer vector_num;
    integer num_errors;

    register dut(
        clk,
        current_vector.reset_n,
        current_vector.store,
        current_vector.enable_a,
        current_vector.enable_b,
        current_vector.store_value,
        register_output.a_out,
        register_output.b_out
    );

    always begin
        clk = 1;
        #5;
        clk = 0;
        #5;
    end

    initial begin
        vector_file = $fopen(`TEST_VECTOR_FILE, "r");
        if (vector_file == 0) begin
            $display("Error: could not open test vector file.");
            $stop;
        end

        vector_num = 0;
        while (!$feof(vector_file)) begin
            c = $fgets(line, vector_file);
            test_vectors[vector_num].reset_n     = $sscanf(line, "%b");
            test_vectors[vector_num].store       = $sscanf(line, "%b");
            test_vectors[vector_num].enable_a    = $sscanf(line, "%b");
            test_vectors[vector_num].enable_b    = $sscanf(line, "%b");
            test_vectors[vector_num].store_value = $sscanf(line, "%h");
            case (line[19:12])
                "zzzzzzzz": test_vectors[vector_num].a_out_expected = `XLEN'hz;
                default:    test_vectors[vector_num].a_out_expected = $sscanf(line, "%h");
            endcase
            case (line[27:20])
                "zzzzzzzz": test_vectors[vector_num].b_out_expected = `XLEN'hz;
                default:    test_vectors[vector_num].b_out_expected = $sscanf(line, "%h");
            endcase
            ++vector_num;
        end

        vector_num = 0;
        num_errors = 0;
        current_vector = test_vectors[vector_num];
    end

    always @(posedge clk) begin
        #1;
        {reset_n, store_value, store, enable_a, enable_b, a_out, b_out}
                = current_vector;
    end

    always @(negedge clk) begin
        if (a_out !== a_out_expected) begin
            $display("Compare error:");
            $display("    reset_n = %b", reset_n);
            $display("      store = %b", store);
            $display("   enable_a = %b", enable_a);
            $display("   enable_b = %b", enable_b);
            $display("store_value = %8h", store_value);
            $display("      a_out = %8h (%8h expected)", a_out, a_out_expected);
            $display("      b_out = %8h (%8h expected)", b_out, b_out_expected);
            num_errors = num_errors + 1;
        end

        vector_num = vector_num + 1;
        current_vector = test_vectors[vector_num];

        if (current_vector === `VECTOR_SIZE'bx) begin
            $display("%d tests completed with %d errors", vector_num,
                     num_errors);
            $stop;
        end
    end

endmodule

