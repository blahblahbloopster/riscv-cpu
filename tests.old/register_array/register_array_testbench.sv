/*
 * Adapted from Harris & Harris Digital Design and Computer Achitecture
 * Example 4.39 HDL Testbench with Test Vector File p 223
 */

`define TEST_VECTOR_FILE "register_array_tests.tv"
`define VECTOR_SIZE 100
`define XLEN 32
`define SELECT_LEN 5
`define VECTOR_DIMENSION 7

module register_array_testbench();

    typedef struct packed {
        logic                   reset_n;
        logic [`SELECT_LEN-1:0] store;
        logic [`SELECT_LEN-1:0] enable_a;
        logic [`SELECT_LEN-1:0] enable_b;
        logic [`XLEN-1:0]       store_value;
        logic [`XLEN-1:0]       a_bus_expected;
        logic [`XLEN-1:0]       b_bus_expected;
    } TestVector;

    typedef struct packed {
        logic [`XLEN-1:0] a_bus;
        logic [`XLEN-1:0] b_bus;
    } RegisterArrayOutput;

    int vector_file;
    reg [8*8-1:0] a_expected_str;
    reg [8*8-1:0] b_expected_str;

    logic clk;
    RegisterArrayOutput register_array_output;
    TestVector current_vector;
    TestVector test_vectors [499:0];
    int vector_num;
    int num_errors;
    int num_vectors;
    int field_count;

    // create instance of register to test
    register_array dut(
        .clk(clk),
        .reset_n(current_vector.reset_n),
        .store(current_vector.store),
        .enable_a(current_vector.enable_a),
        .enable_b(current_vector.enable_b),
        .store_value(current_vector.store_value),
        .a_bus(register_array_output.a_bus),
        .b_bus(register_array_output.b_bus)
    );

    // define clock
    always begin
        clk = 1;
        #5;
        clk = 0;
        #5;
    end

    initial begin
        // open test vector file
        vector_file = $fopen(`TEST_VECTOR_FILE, "r");
        if (vector_file == 0) begin
            $display("Error: could not open test vector file.");
            $stop;
        end

        // read test vectors
        vector_num = 0;
        while (!$feof(vector_file)) begin
            field_count = $fscanf(vector_file, "%b %h %h %h %h %s %s\n",
                    test_vectors[vector_num].reset_n,
                    test_vectors[vector_num].store,
                    test_vectors[vector_num].enable_a,
                    test_vectors[vector_num].enable_b,
                    test_vectors[vector_num].store_value,
                    a_expected_str,
                    b_expected_str,
            );

            // ensure all fields were read
            if (field_count != `VECTOR_DIMENSION) begin
                $display("Error reading file at line %d.", vector_num + 1);
                $display("Expected %d fields, found %d", `VECTOR_DIMENSION,
                         field_count);
                $stop;
            end

            // check for high impedance outputs
            case (a_expected_str)
                "zzzzzzzz": test_vectors[vector_num].a_bus_expected = `XLEN'hz;
                default: field_count = $sscanf(a_expected_str, "%h",
                        test_vectors[vector_num].a_bus_expected);
            endcase
            case (b_expected_str)
                "zzzzzzzz": test_vectors[vector_num].b_bus_expected = `XLEN'hz;
                default: field_count = $sscanf(b_expected_str, "%h",
                        test_vectors[vector_num].b_bus_expected);
            endcase

            ++vector_num;
        end

        // cleanup
        $fclose(vector_file);
        num_vectors = vector_num;
        vector_num = 0;
        num_errors = 0;
        current_vector = test_vectors[vector_num];
    end

    // load test vector shortly after each clock rising edge
    always @(posedge clk) begin
        #1;
        current_vector = test_vectors[vector_num];
    end

    // compare with outputs on clock falling edge
    always @(negedge clk) begin
        if (register_array_output.a_bus !== current_vector.a_bus_expected
         || register_array_output.b_bus !== current_vector.b_bus_expected) begin
            $display("Compare error at vector #%d:", vector_num);
            $display("    reset_n = %b", current_vector.reset_n);
            $display("      store = %b", current_vector.store);
            $display("   enable_a = %b", current_vector.enable_a);
            $display("   enable_b = %b", current_vector.enable_b);
            $display("store_value = %8h", current_vector.store_value);
            $display("      a_out = %8h (%8h expected)",
                    register_array_output.a_bus, current_vector.a_bus_expected);
            $display("      b_out = %8h (%8h expected)",
                    register_array_output.b_bus, current_vector.b_bus_expected);
            $display("");
            num_errors = num_errors + 1;
        end

        // halt once all vectors are processed
        if (vector_num >= num_vectors) begin
            $display("%d tests completed with %d errors", vector_num, num_errors);
            $stop;
        end

        vector_num = vector_num + 1;
    end

endmodule

