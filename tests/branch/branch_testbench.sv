/*
 * Adapted from Harris & Harris Digital Design and Computer Achitecture
 * Example 4.39 HDL Testbench with Test Vector File p 223
 */

`define TEST_VECTOR_FILE "branch_tests.tv"
`define NUM_TESTS 500
`define VECTOR_SIZE 271
`define VECTOR_DIMENSION 13
`define XLEN 32
`define REG_SELECT_LEN 5

module program_counter_testbench();

    typedef struct packed {
        logic enable_n;
        logic [`XLEN-1:0] instruction;
        logic [`XLEN-1:0] program_counter;
        logic [`XLEN-1:0] register_data_1;
        logic [`XLEN-1:0] register_data_2;
        logic [`XLEN-1:0] alu_out;
    } Inputs;

    typedef struct packed {
        logic [`REG_SELECT_LEN-1:0] register_1;
        logic [`REG_SELECT_LEN-1:0] register_2;
        logic [`XLEN-1:0] alu_a;
        logic [`XLEN-1:0] alu_b;
        logic [2:0] alu_op;
        logic load_new_pc;
        logic [`XLEN-1:0] new_pc;
    } Outputs;

    typedef struct packed {
        Inputs inputs;
        Outputs expected;
    } TestVector;

    typedef struct packed {
        reg [8*5-1:0] register_1;
        reg [8*5-1:0] register_2;
        reg [8*8-1:0] alu_a;
        reg [8*8-1:0] alu_b;
        reg [8*3-1:0] alu_op;
        reg [8*1-1:0] load_new_pc;
        reg [8*8-1:0] new_pc;
    } OutputSrtings;

    int vector_file;
    OutputStrings output_strings;

    logic clk;
    BranchOutput branch_output;
    TestVector current_vector;
    TestVector test_vectors [`NUM_TESTS-1:0];
    int vector_num;
    int num_errors;
    int num_vectors;
    int field_count;

    // create instance of program_counter to test
    branch dut(
        .clk(clk),
        .enable_n(current_vector.enable_n),
        .instruction(current_vector.instruction),
        .program_counter(current_vector.program_counter),
        .register_data_1(current_vector.register_data_1),
        .register_data_2(current_vector.register_data_2),
        .alu_out(current_vector.alu_out)
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
            field_count = $fscanf(vector_file,
                    "%b %h %h %s %s %h %h %s %s %s %h %s %s\n",
                    test_vectors[vector_num].inputs.enable_n,

                    test_vectors[vector_num].inputs.instruction,
                    test_vectors[vector_num].inputs.program_counter,

                    output_strings.register_1,
                    output_strings.register_2,
                    test_vectors[vector_num].inputs.register_data_1,
                    test_vectors[vector_num].inputs.register_data_2,

                    output_strings.alu_a,
                    output_strings.alu_b,
                    output_strings.alu_op,
                    test_vectors[vector_num].inputs.alu_out,

                    output_strings.load_new_pc,
                    output_strings.new_pc
            );

            // ensure all fields were read
            if (field_count != `VECTOR_DIMENSION) begin
                $display("Error reading file a line %d.", vector_num + 1);
                $display("Expected %d fields, found %d", `VECTOR_DIMENSION,
                         field_count);
                $stop;
            end

            // check for high impedance outputs
            case (output_strings.reg_1)
                "zzzzzzzz": test_vectors[vector_num].expected.register_1 = `XLEN'hz;
                default: field_count = $sscanf(output_strings.reg_1, "%h",
                        test_vectors[vector_num].expected.register_1);
            endcase

            case (output_strings.reg_2)
                "zzzzzzzz": test_vectors[vector_num].expected.register_2 = `XLEN'hz;
                default: field_count = $sscanf(output_strings.reg_2, "%h",
                        test_vectors[vector_num].expected.register_2);
            endcase

            case (output_strings.alu_a)
                "zzzzzzzz": test_vectors[vector_num].expected.alu_a = `XLEN'hz;
                default: field_count = $sscanf(output_strings.alu_a, "%h",
                        test_vectors[vector_num].expected.alu_a);
            endcase

            case (output_strings.alu_b)
                "zzzzzzzz": test_vectors[vector_num].expected.alu_b = `XLEN'hz;
                default: field_count = $sscanf(output_strings.alu_b, "%h",
                        test_vectors[vector_num].expected.alu_b);
            endcase

            case (output_strings.alu_op)
                "zzz": test_vectors[vector_num].expected.alu_op = 3'hz;
                default: field_count = $sscanf(output_strings.alu_op, "%h",
                        test_vectors[vector_num].expected.alu_op);
            endcase

            case (output_strings.load_new_pc)
                "z": test_vectors[vector_num].expected.load_new_pc = 1'hz;
                default: field_count = $sscanf(output_strings.load_new_pc, "%h",
                        test_vectors[vector_num].expected.load_new_pc);
            endcase

            case (output_strings.new_pc)
                "zzzzzzzz": test_vectors[vector_num].expected.new_pc = 1'hz;
                default: field_count = $sscanf(output_strings.new_pc, "%h",
                        test_vectors[vector_num].expected.new_pc);
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

    // compare with outputs on clock falling edge
    always @(negedge clk) begin
        if (branch_output !== current_vector.expected) begin
            $display("Compare error at vector #%d:", vector_num);
            $display("       enable_n = %h", current_vector.enable_n);
            $display("    instruction = %h", current_vector.instruction);
            $display("program_counter = %h", current_vector.program_counter);
            $display("register_data_1 = %h", current_vector.register_data_1);
            $display("register_data_2 = %h", current_vector.register_data_2);
            $display("        alu_out = %h", current_vector.alu_out);
            $display("");
            $display("     register_1 = %h (%8h expected)",
                     branch_output.register_1,
                     current_vector.expected.register_1);
            $display("     register_2 = %h (%8h expected)",
                     branch_output.register_2,
                     current_vector.expected.register_2);
            $display("          alu_a = %h (%8h expected)",
                     branch_output.alu_a,
                     current_vector.expected.alu_a);
            $display("          alu_b = %h (%8h expected)",
                     branch_output.alu_b,
                     current_vector.expected.alu_b);
            $display("         alu_op = %h (%1h expected)",
                     branch_output.alu_op,
                     current_vector.expectedd.alu_op);
            $display("    load_new_pc = %h (%1h expected)",
                     branch_output.load_new_pc,
                     current_vector.expected.load_new_pc);
            $display("         new_pc = %h (%8h expected)",
                     branch_output.new_pc,
                     current_vector.expected.new_pc);
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

    // load test vector shortly before each clock rising edge
    always @(negedge clk) begin
        #4;
        current_vector = test_vectors[vector_num];
    end

endmodule

