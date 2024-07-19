/*
 * Adapted from Harris & Harris Digital Design and Computer Architecture
 * Example 4.39 HDL Testbench with Test Vector File p 223
 */

`define TEST_VECTOR_FILE_PATH "vectors/alu_reg_imm.tv"
`define VECTOR_DIM 6
`define XLEN 32

module alu_reg_imm_tb();

    typedef struct packed {
        logic               enable_n;
        logic [2:0]         funct3;
        logic               alt_funct;
        logic [`XLEN-1:0]   a;
        logic [11:0]        imm;
    } Inputs;

    typedef struct packed {
        logic [`XLEN-1:0]   result;
    } Outputs;

    typedef struct packed {
        reg [`XLEN*8-1:0]   result;
    } OutputStrings;

    typedef struct packed {
        Inputs              inputs;
        Outputs             expected;
    } TestVector;

    logic                   clk;

    TestVector              vector;
    Outputs                 outputs;

    logic [`XLEN-1:0]       alu_b;

    int                     vector_file;
    int                     field_count;
    int unsigned            vector_num;
    int unsigned            num_errors;

    task open_file;
        input  string   file_path;
        output int      file;
    begin
        string _header;

        // Open test vector file
        file = $fopen(file_path, "r");
        if (file == 0) begin
            $display("Error: could not open test vector file %s.", file_path);
            $stop;
        end

        // Ignore header
        $fgets(_header, file);
        $display("Header: %s", _header);  // Debugging header content
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
            "%h %h %h %s %h %h\n",
            tv.inputs.funct3,
            tv.inputs.alt_funct,
            tv.inputs.enable_n,
            output_str.result,
            tv.inputs.a,
            tv.inputs.imm
        );

        // Ensure all fields were read
        if (field_count != `VECTOR_DIM) begin
            $display("Error reading file at line %3d.", vector_num + 1);
            $display("Expected %1d fields, found %1d", `VECTOR_DIM, field_count);
            $stop;
        end

        // Convert expected strings to logic
        if (output_str.result == "zzzzzzzz") begin
            tv.expected.result = 32'hzzzzzzzz;
        end else begin
            field_count = $sscanf(output_str.result, "%h", tv.expected.result);
        end

        vector_num = vector_num + 1;
    end
    endtask

    // If DUT output doesn't equal expected output, print debug info
    task check_vector;
        input TestVector    tv;
        input Outputs       out;
        inout int           num_errors;
    begin
        if (out !== tv.expected) begin
            $display("Compare error:");
            $display("funct3 = %01h", tv.inputs.funct3);
            $display("  alt  = %01h", tv.inputs.alt_funct);
            $display("     a = %08h", tv.inputs.a);
            $display("   imm = %03h", tv.inputs.imm);
            $display("result = %08h (%08h expected)", out.result, tv.expected.result);
            num_errors = num_errors + 1;
        end
    end
    endtask

    assign alu_b = $signed(vector.inputs.imm);

    alu dut(
        vector.inputs.enable_n,
        vector.inputs.funct3,
        vector.inputs.alt_funct,
        vector.inputs.a,
        alu_b,
        outputs.result
    );

    always begin
        clk = 1;
        #5;
        clk = 0;
        #5;
    end

    initial begin
        vector_num = 0;
        num_errors = 0;
        open_file(`TEST_VECTOR_FILE_PATH, vector_file);
    end

    always @(posedge clk) begin
        #1;
        read_next_vector(vector_file, vector, vector_num);
    end

    always @(negedge clk) begin
        check_vector(vector, outputs, num_errors);

        if ($feof(vector_file)) begin
            $display(
                "%3d tests completed with %3d errors",
                 vector_num,
                 num_errors
            );
            $fclose(vector_file);
            $stop;
        end
    end

endmodule
