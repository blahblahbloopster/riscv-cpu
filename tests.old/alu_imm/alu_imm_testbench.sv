/*
 * Adapted from Harris & Harris Digital Design and Computer Achitecture
 * Example 4.39 HDL Testbench with Test Vector File p 223
 */

`define TEST_VECTOR_FILE "alu_imm_tests.tv"
`define NUM_TESTS 50
`define VECTOR_SIZE 207
`define XLEN 32
`define REG_SELECT_LEN 5
`define VECTOR_DIMENSION 11

module alu_imm_testbench();

    typedef struct packed {
        logic             enable_n;
        logic [`XLEN-1:0] instruction;
        logic [`XLEN-1:0] register_src_data;
        logic [`XLEN-1:0] alu_out;
    } Inputs;

    typedef struct packed {
        logic [`REG_SELECT_LEN-1:0] register_src;
        logic [`XLEN-1:0] alu_a;
        logic [`XLEN-1:0] alu_b;
        logic [2:0]       alu_op;
        logic             alu_signal;
        logic [`REG_SELECT_LEN-1:0] register_dest;
        logic [`XLEN-1:0] register_dest_data;
    } Outputs;

    typedef struct packed {
        Inputs inputs;
        Outputs expected;
    } TestVector;

    typedef struct packed {
        reg [5*8-1:0] register_src;
        reg [8*8-1:0] alu_a;
        reg [8*8-1:0] alu_b;
        reg [1*8-1:0] alu_op;
        reg [1*8-1:0] alu_signal;
        reg [5*8-1:0] register_dest;
        reg [8*8-1:0] register_dest_data;
    } OutputStrings;

    int vector_file;
    OutputString output_strings;

    logic clk;
    Outputs alu_imm_outputs;
    TestVector current_vector;
    TestVector test_vectors [`NUM_TESTS-1:0];
    int vector_num;
    int num_errors;
    int num_vectors;
    int field_count;

    alu alu (
        .enable_n(current_vector.enable_n),
        .opcode(dut.alu_op),
        .signal(dut.alu_signal),
        .a(dut.alu_a),
        .b(dut.alu_b),
        .result(dut.alu_result)
    );

    // create instance of alu_imm to test
    alu_imm dut(
        .clk(clk),
        .enable_n(current_vector.enable_n),
        .instruction(current_vector.instruction),
        .register_src(alu_imm_outputs.register_src),
        .register_src_data(current_vector.register_src_data),
        .alu_a(alu_imm_outputs.alu_a),
        .alu_b(alu_imm_outputs.alu_b),
        .alu_op(alu_imm_outputs.alu_op),
        .alu_signal(alu_imm_outputs.alu_signal),
        .alu_out(current_vector.alu_out),
        .register_dest(alu_imm_outputs.register_dest),
        .register_dest_data(alu_imm_outputs.register_dest_data)
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

        vector_num = 0;
        while (!$feof(vector_file)) begin
            field_count = $fscanf(vector_file,
                    "%b %h %s %h %s %s %s %s %h %s %s\n",
                    test_vectors[vector_num].inputs.enable_n,

                    test_vectors[vector_num].inputs.instruction,

                    output_strings.register_src,
                    test_vectors[vector_num].inputs.register_src_data,

                    output_strings.alu_a,
                    output_strings.alu_b,
                    output_strings.alu_op,
                    output_strings.alu_signal,
                    test_vectors[vector_num].inputs.alu_out,

                    output_strings.register_dest,
                    output_strings.register_dest_data
            );

            // ensure all fields were read
            if (field_count != `VECTOR_DIMENSION) begin
                $display("Error reading file a line %d.", vector_num + 1);
                $display("Expected %d fields, found %d", `VECTOR_DIMENSION,
                         field_count);
                $stop;
            end

            // check for high impedance outputs
            case (output_strings.register_src)
                "zzzzz": test_vectors[vector_num].expected.register_src = `XLEN'hz;
                default: field_count = $sscanf(output_strings.register_src, "%h",
                        test_vectors[vector_num].expected.register_src);
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
                "z": test_vectors[vector_num].expected.alu_op = 1'hz;
                default: field_count = $sscanf(output_strings.alu_op, "%h",
                        test_vectors[vector_num].expected.alu_op);
            endcase

            case (output_strings.alu_signal)
                "z": test_vectors[vector_num].expected.alu_signal = 1'hz;
                default: field_count = $sscanf(output_strings.alu_signal, "%h",
                        test_vectors[vector_num].expected.alu_op);
            endcase

            case (output_strings.register_dest)
                "zzzzz": test_vectors[vector_num].expected.register_dest = `XLEN'hz;
                default: field_count = $sscanf(output_strings.register_dest, "%h",
                        test_vectors[vector_num].expected.register_dest);
            endcase

            case (output_strings.register_dest_data)
                "zzzzzzzz": test_vectors[vector_num].expected.register_dest_data = `XLEN'hz;
                default: field_count = $sscanf(output_strings.register_dest_data, "%h",
                        test_vectors[vector_num].expected.register_dest_data);
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
        if (branch_outputs !== current_vector.expected) begin
            $display("Compare error at vector %d:", vector_num);
            $display("          enable_n = %h", current_vector.inputs.enable_n);
            $display("       instruction = %h", current_vector.inputs.instruction);
            $display(" register_src_data = %h", current_vector.inputs.register_data_1);
            $display("           alu_out = %h", current_vector.inputs.alu_out);
            $display("");
            $display("      register_src = %h (%2h expected)",
                     alu_imm_outputs.register_src,
                     current_vector.expected.register_src);
            $display("           alu_a = %h (%1h expected)",
                     alu_imm_outputs.alu_a,
                     current_vector.expected.alu_a);
            $display("           alu_b = %h (%8h expected)",
                     alu_imm_outputs.alu_b,
                     current_vector.expected.alu_b);
            $display("          alu_op = %h (%1h expected)",
                     alu_imm_outputs.alu_op,
                     current_vector.expected.alu_op);
            $display("      alu_signal = %h (%1h expected)",
                     alu_imm_outputs.alu_signal,
                     current_vector.expected.alu_signal);
            $display("     register_dest = %h (%2h expected)",
                     alu_imm_outputs.register_dest,
                     current_vector.expected.register_dest);
            $display("register_dest_data = %h (%2h expected)",
                     alu_imm_outputs.register_dest_data,
                     current_vector.expected.register_dest_data);
            $display("");
            num_errors = num_errors + 1;
        end

        vector_num = vector_num + 1;

        // halt once all vectors are processed
        if (vector_num >= num_vectors) begin
            $display("%d tests completed with %d errors", vector_num, num_errors);
            $stop;
        end
    end

    // load test vector shortly before each clock rising edge
    always @(negedge clk) begin
        #4;
        current_vector = test_vectors[vector_num];
    end

endmodule

