`define XLEN 32
`define REG_SELECT_LEN 5
`define BUS_HI_Z `XLEN'hzzzzzzzz
`define SELECT_HI_Z `REG_SELECT_LEN'bzzzzz

module auipc (
    input  logic             clk,
    input  logic             enable_n,

    input  logic [`XLEN-1:0] instruction,
    input  logic [`XLEN-1:0] program_counter,

    output logic [`XLEN-1:0] alu_a,
    output logic [`XLEN-1:0] alu_b,
    output logic [2:0]       alu_op,
    output logic             alu_sig;
    input  logic [`XLEN-1:0] alu_out,

    output logic [`REG_SELECT_LEN-1:0] output_register,
    output logic [`XLEN-1:0] output_register_data
);

    always_comb begin
        if (!enable_n) begin

            alu_a = program_counter;
            alu_b = {instruction[31:12], 3'h000};
            alu_op = 3'b000;
            alu_sig = 0'b0;

            output_register = instruction[11:7];
            output_register_data = alu_out;
        end else begin
            alu_a = `BUS_HI_Z;
            alu_b = `BUS_HI_Z;
            alu_op = 3'bzzz;
            alu_sig = 1'bz;
            output_register = `SELECT_HI_Z;
            output_register_data = `BUS_HI_Z;
        end
    end

endmodule

