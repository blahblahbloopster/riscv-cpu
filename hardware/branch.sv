`define XLEN 32
`define REG_LEN 5
`define BUS_HI_Z `XLEN'hzzzzzzzz
`define SELECT_HI_Z `REG_LEN'bzzzzz

module branch (
    input logic                 clk,
    input logic                 enable_n,

    input logic [`XLEN-1:0]     pc,

    input logic [`XLEN-1:0]     rs1_val,
    input logic [`XLEN-1:0]     rs2_val,
    input logic [2:0]           funct3,
    input logic [11:0]          imm12,

    // move to cpu.sv?
    // output logic [2:0]           alu_funct3,
    // output logic                 alu_alt_funct,

    input logic [`XLEN-1:0]     alu_result,

    output logic                branch,
    output logic [`XLEN-1:0]    branch_pc
);

    logic [12:0] offset;

    always_comb begin
        if (!enable_n) begin
            offset = {imm12, 1'b0};

            // alu_op = {~funct3[2], funct3[2], funct3[1]};
            // alu_alt_funct = 0'b0;
            branch = |alu_result ^ funct3[0];

            branch_pc = program_counter + offset;
        end else begin
            branch = 1'bz;
            branch_pc = `BUS_HI_Z;
        end
    end

endmodule

