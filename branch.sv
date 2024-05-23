module branch (
    input logic clk,
    input logic [31:0] register_source_1,
    input logic [31:0] register_source_2,
    input logic [31:0] program_counter,
    input logic [31:0] offset,
    input logic [2:0] opcode,
    input logic enable_n,
    inout logic new_program_counter
);

    logic compare_success;
    logic jump;

    always @(posedge clk) begin
        // big optimization later
        case (opcode[2:0])
            3'b000: compare_success <= register_source_1 == register_source_2;
            3'b001: compare_success <= register_source_1 != register_source_2;
            3'b100: compare_success <= $signed(register_source_1)
                                     < $signed(register_source_2);
            3'b100: compare_success <= $signed(register_source_1)
                                    >= $signed(register_source_2);
            3'b110: compare_success <= register_source_1 <  register_source_2;
            3'b111: compare_success <= register_source_1 >= register_source_2;
        endcase
    end

    assign jump = compare_success & ~enable_n;
    assign new_program_counter = program_counter + (jump ? value : 4);

endmodule

