/*
 * Adapted from Harris & Harris Digital Design and Computer Achitecture
 * Example 4.39 HDL Testbench with Test Vector File p 223
 */

`define TEST_VECTOR_FILE "../tests/alu_reg_reg.tv"
`define NUM_TESTS 10000
`define VECTOR_SIZE 81
`define VECTOR_DIM 6
`define XLEN 32

module alu_testbench();

    typedef struct packed {
        logic               enable_n;
        logic [2:0]         funct3;
        logic               alt_funct;
        logic               enable_n;
        logic [`XLEN-1:0]   a;
        logic [`XLEN-1:0]   b;
    } Inputs;

    typedef struct packed {
        logic [`XLEN-1:0]   result;
    } Outputs;

    typedef struct packed {
        logic [`XLEN*8-1:0] result_str;
    } OutputStrings;

    typedef struct packed {
        Inputs              inputs;
        Outputs             expected;
    } TestVector;

    logic                   clk;

    TestVector              vector;
    Outputs                 outputs;

    int                     vector_file;
    int                     field_count;
    logic [`XLEN-1:0]       vector_num;
    logic [`XLEN-1:0]       num_errors;

    alu dut(
        vector.inputs.enable_n,
        vector.inputs.funct3,
        vector.inputs.alt_funct,
        vector.inputs.a,
        vector.inputs.b,
        output.result,
    );

    always begin
        clk = 1;
        #5;
        clk = 0;
        #5;
    end

    initial begin
        // Open test vector file
        vector_file = $fopen(`TEST_VECTOR_FILE, "r");
        if (vector_file == 0) begin
            $display("Error: could not open test vector file.");
            $stop;
        end

        // Ignore header
        field_count = $fscanf(vector_file, "%s\n");
    end

    // Convert string to logic value.
    // A string of "z" sets all bits of `val` to z.
    // A string of hex sets `val` to the hex value.
    task to_logic;
        input  string           str;
        input  int              len;
        output logic [len-1:0]  val;
    begin
        int str_len = len / 4;
        int char_count;
        case (str)
            {str_len{"z"}}: val = len{1'hz};
            default: begin
                char_count = $sscanf(str, "%h", val);
                if (char_count != str_len) begin
                    $display("Error converting string %s to logic", str);
                    $display("Expected %d chars, found %d", str_len, char_count);
                    $stop;
                end
            end
        endcase
    end
    endtask

    // Read next test vector in vector file
    task read_next_vector;
        input  int          fd;
        output TestVector   tv;
        inout  int          vector_num;
    begin
        int                 field_count;
        OutputStrings       output_str;

        // Read file line
        field_count = $fscanf(
            fd,
            "%01h %01h %01h %08h %08h %08h\n",
            tv.inputs.funct3,
            tv.inputs.alt_funct,
            tv.inputs.enable_n,
            output_str.result,
            tv.inputs.a,
            tv.inputs.b
        );

        // Ensure all fields were read
        if (field_count != `VECTOR_DIMENSION) begin
            $display("Error reading file at line %d.", vector_num + 1);
            $display("Expected %d fields, found %d", `VECTOR_DIMENSION, field_count);
            $stop;
        end

        // Convert expected strings to logic
        to_logic(output_strings.result, vector.expected.result, `XLEN);

        vector_num = vector_num + 1;
    end
    endtask

    // If DUT output doesn't equal expected output, print debug info
    task check_vector;
        input TestVector    tv;
        input Outputs       out;
        inout int           num_errors;
    begin
        if (out !== vector.expected) begin
            $display("Compare error:");
            $display("funct3 = %b", vector.inputs.funct3);
            $display("     a = %h", vector.inputs.a);
            $display("     b = %h", vector.inputs.b);
            $display("result = %h (%h expected)", result, vector.expected.result);
            num_errors = num_errors + 1;
        end
    end
    endtask

    always @(posedge clk) begin
        #1;
        read_next_vector(vector_file, vector, vector_num);
    end

    always @(negedge clk) begin
        check_vector(vector, outputs, num_errors);

        if ($feof(vector_file) || vector === 100'bx) begin
            $display(
                "%d tests completed with %d errors",
                 vector_num,
                 num_errors
            );
            $finish;
        end
    end

endmodule
