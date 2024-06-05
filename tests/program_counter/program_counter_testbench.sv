/*
 * Adapted from Harris & Harris Digital Design and Computer Achitecture
 * Example 4.39 HDL Testbench with Test Vector File p 223
 */

`define TEST_VECTOR_FILE "register_tests.tv"
`define VECTOR_SIZE 100
`define XLEN 32
`define VECTOR_DIMENSION 7

module register_testbench();

    typedef struct packed {
        logic             reset_n;
        logic             enable_n;
        logic             load_new_address;
        logic [`XLEN-1:0] new_address;
        logic [`XLEN-1:0] address_expected;
    } TestVector;

    typedef struct packed {
        logic [`XLEN-1:0] address;
    } ProgramCounterOutput;

    int vector_file;
    reg [8*8-1:0] address_expected_str;

    logic clk;
    RegisterOutput pc_output;
    TestVector current_vector;
    TestVector test_vectors [499:0];
    int vector_num;
    int num_errors;
    int num_vectors;
    int field_count;

    // create instance of register to test
    program_counter dut(
        .clk(clk),
        .reset_n(current_vector.reset_n),
        .enable_n(current_vector.enable_n),
        .load_new_address(current_vector.load_new_address),
        .new_address(current_vector.new_address),
        .address(pc_output.address),
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
            field_count = $fscanf(vector_file, "%b %b %b %h %s\n",
                    test_vectors[vector_num].reset_n,
                    test_vectors[vector_num].enable_n,
                    test_vectors[vector_num].load_new_address,
                    test_vectors[vector_num].new_address,
                    address_expected_str,
            );

            // ensure all fields were read
            if (field_count != `VECTOR_DIMENSION) begin
                $display("Error reading file a line %d.", vector_num + 1);
                $display("Expected %d fields, found %d", `VECTOR_DIMENSION,
                         field_count);
                $stop;
            end

            // check for high impedance outputs
            case (address_expected_str)
                "zzzzzzzz": test_vectors[vector_num].address_expected = `XLEN'hz;
                default: field_count = $sscanf(address_expected_str, "%h",
                        test_vectors[vector_num].address_expected);
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
        if (pc_output.address !== current_vector.address_expected) begin
            $display("Compare error at vector #%d:", vector_num);
            $display("    reset_n = %b", current_vector.reset_n);
            $display("   enable_n = %b", current_vector.enable_n);
            $display("       load = %b", current_vector.load_new_address);
            $display("    address = %8h (%8h expected)", pc_output.address,
                     current_vector.address_expected);
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

