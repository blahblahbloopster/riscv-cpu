`define XLEN 32
`define REG_SELECT_LEN 5
`define BUS_HI_Z `XLEN'hzzzzzzzz
`define SELECT_HI_Z `REG_SELECT_LEN'bzzzzz

module jal (
    input  logic clk,
    input  logic enable_n,

    input  logic [`XLEN-1:0] instruction,
    input  logic [`XLEN-1:0] program_counter,

    output logic [`XLEN-1:0] alu_a,
    output logic [`XLEN-1:0] alu_b,
    output logic [2:0]       alu_op,
    output logic             alu_signal;
    input  logic [`XLEN-1:0] alu_out,

    output logic             load_new_program_counter,
    output logic [`XLEN-1:0] new_program_counter,

    output logic [`REG_SELECT_LEN-1:0] output_register,
    output logic [`XLEN-1:0] output_register_data
);

    always_comb begin
        if (!enable_n) begin
            alu_a = program_counter;
            alu_b = $signed({instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0});

            alu_op = 3'b000;
            alu_signal = 1'b0;

            output_register = instruction[11:7];
            output_register_data = program_counter + 4;

            load_new_program_counter = 1'b1;
            new_program_counter = alu_out;
        end else begin
            alu_a = `BUS_HI_Z;
            alu_b = `BUS_HI_Z;
            alu_op = 3'bzzz;
            alu_signal = 1'bz;
            load_new_program_counter = 1'bz;
            new_program_counter = `BUS_HI_Z;
            output_register = `SELECT_HI_Z;
            output_register_data = `BUS_HI_Z;
        end
    end

endmodule

