`define XLEN 32
`define REG_SELECT_LEN 5
`define BUS_HI_Z `XLEN'hzzzzzzzz
`define SELECT_HI_Z `REG_SELECT_LEN'bzzzzz

module alu_imm (
    input  logic             clk,
    input  logic             enable_n,

    input  logic [`XLEN-1:0] instruction,

    output logic [`REG_SELECT_LEN-1:0] register_src,
    input  logic [`XLEN-1:0]           register_src_data,

    output logic [`XLEN-1:0] alu_a,
    output logic [`XLEN-1:0] alu_b,
    output logic [2:0]       alu_op,
    output logic             alu_signal,
    input  logic [`XLEN-1:0] alu_out,

    output logic [`REG_SELECT_LEN-1:0] register_dest,
    output logic [`XLEN-1:0] register_dest_data
);

    always @(posedge clk) begin
        if (!enable_n) begin
            register_1 <= instruction[19:15];
        end else begin
            register_1 <= `SELECT_HI_Z;
        end
    end

    always_comb begin
        if (!enable_n) begin

            alu_a = register_data_1;
            alu_b = {5'h00000, instruction[31:20]};
            alu_op = instruction[14:12];
            alu_sig = instruction[30];

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

