`define XLEN 32
`define REG_LEN 5
`define HI_Z `XLEN'hzzzzzzzz
`define ZERO `XLEN'h00000000

module register_array (
    input  logic                    clk,
    input  logic                    reset_n,
    input  logic                    enable_n,
    input  logic [`SELECT_LEN-1:0]  rs1,
    input  logic [`SELECT_LEN-1:0]  rs2,
    input  logic [`SELECT_LEN-1:0]  rd,
    input  logic [`XLEN-1:0]        rd_val,
    output logic [`XLEN-1:0]        rs1_val,
    output logic [`XLEN-1:0]        rs2_val
);

    logic [`XLEN-1:0]               rs1_decoded;
    logic [`XLEN-1:0]               rs2_decoded;
    logic [`XLEN-1:0]               rd_decoded;

    tri [`XLEN-1:0]                 rs1_val_internal;
    tri [`XLEN-1:0]                 rs2_val_internal;

    always_comb begin
        rd_decoded = !enable_n ? `XLEN'b1 << rd : `ZERO;
        rs1_decoded = !enable_n ? `XLEN'b1 << rs1 : `ZERO;
        rs2_decoded = !enable_n ? `XLEN'b1 << rs2 : `ZERO;
        rs1_val = !enable_n ? rs1_val_internal : `HI_Z;
        rs2_val = !enable_n ? rs2_val_internal : `HI_Z;
    end

    zero_register X0(clk, reset_n, rs1_decoded[0], rs2_decoded[0], rs1_val_internal, rs2_val_internal);
    register X1(clk, reset_n, rd_decoded[1], rs1_decoded[1], rs2_decoded[1], rd_val, rs1_val_internal, rs2_val_internal);
    register X2(clk, reset_n, rd_decoded[2], rs1_decoded[2], rs2_decoded[2], rd_val, rs1_val_internal, rs2_val_internal);
    register X3(clk, reset_n, rd_decoded[3], rs1_decoded[3], rs2_decoded[3], rd_val, rs1_val_internal, rs2_val_internal);
    register X4(clk, reset_n, rd_decoded[4], rs1_decoded[4], rs2_decoded[4], rd_val, rs1_val_internal, rs2_val_internal);
    register X5(clk, reset_n, rd_decoded[5], rs1_decoded[5], rs2_decoded[5], rd_val, rs1_val_internal, rs2_val_internal);
    register X6(clk, reset_n, rd_decoded[6], rs1_decoded[6], rs2_decoded[6], rd_val, rs1_val_internal, rs2_val_internal);
    register X7(clk, reset_n, rd_decoded[7], rs1_decoded[7], rs2_decoded[7], rd_val, rs1_val_internal, rs2_val_internal);
    register X8(clk, reset_n, rd_decoded[8], rs1_decoded[8], rs2_decoded[8], rd_val, rs1_val_internal, rs2_val_internal);
    register X9(clk, reset_n, rd_decoded[9], rs1_decoded[9], rs2_decoded[9], rd_val, rs1_val_internal, rs2_val_internal);
    register X10(clk, reset_n, rd_decoded[10], rs1_decoded[10], rs2_decoded[10], rd_val, rs1_val_internal, rs2_val_internal);
    register X11(clk, reset_n, rd_decoded[11], rs1_decoded[11], rs2_decoded[11], rd_val, rs1_val_internal, rs2_val_internal);
    register X12(clk, reset_n, rd_decoded[12], rs1_decoded[12], rs2_decoded[12], rd_val, rs1_val_internal, rs2_val_internal);
    register X13(clk, reset_n, rd_decoded[13], rs1_decoded[13], rs2_decoded[13], rd_val, rs1_val_internal, rs2_val_internal);
    register X14(clk, reset_n, rd_decoded[14], rs1_decoded[14], rs2_decoded[14], rd_val, rs1_val_internal, rs2_val_internal);
    register X15(clk, reset_n, rd_decoded[15], rs1_decoded[15], rs2_decoded[15], rd_val, rs1_val_internal, rs2_val_internal);
    register X16(clk, reset_n, rd_decoded[16], rs1_decoded[16], rs2_decoded[16], rd_val, rs1_val_internal, rs2_val_internal);
    register X17(clk, reset_n, rd_decoded[17], rs1_decoded[17], rs2_decoded[17], rd_val, rs1_val_internal, rs2_val_internal);
    register X18(clk, reset_n, rd_decoded[18], rs1_decoded[18], rs2_decoded[18], rd_val, rs1_val_internal, rs2_val_internal);
    register X19(clk, reset_n, rd_decoded[19], rs1_decoded[19], rs2_decoded[19], rd_val, rs1_val_internal, rs2_val_internal);
    register X20(clk, reset_n, rd_decoded[20], rs1_decoded[20], rs2_decoded[20], rd_val, rs1_val_internal, rs2_val_internal);
    register X21(clk, reset_n, rd_decoded[21], rs1_decoded[21], rs2_decoded[21], rd_val, rs1_val_internal, rs2_val_internal);
    register X22(clk, reset_n, rd_decoded[22], rs1_decoded[22], rs2_decoded[22], rd_val, rs1_val_internal, rs2_val_internal);
    register X23(clk, reset_n, rd_decoded[23], rs1_decoded[23], rs2_decoded[23], rd_val, rs1_val_internal, rs2_val_internal);
    register X24(clk, reset_n, rd_decoded[24], rs1_decoded[24], rs2_decoded[24], rd_val, rs1_val_internal, rs2_val_internal);
    register X25(clk, reset_n, rd_decoded[25], rs1_decoded[25], rs2_decoded[25], rd_val, rs1_val_internal, rs2_val_internal);
    register X26(clk, reset_n, rd_decoded[26], rs1_decoded[26], rs2_decoded[26], rd_val, rs1_val_internal, rs2_val_internal);
    register X27(clk, reset_n, rd_decoded[27], rs1_decoded[27], rs2_decoded[27], rd_val, rs1_val_internal, rs2_val_internal);
    register X28(clk, reset_n, rd_decoded[28], rs1_decoded[28], rs2_decoded[28], rd_val, rs1_val_internal, rs2_val_internal);
    register X29(clk, reset_n, rd_decoded[29], rs1_decoded[29], rs2_decoded[29], rd_val, rs1_val_internal, rs2_val_internal);
    register X30(clk, reset_n, rd_decoded[30], rs1_decoded[30], rs2_decoded[30], rd_val, rs1_val_internal, rs2_val_internal);
    register X31(clk, reset_n, rd_decoded[31], rs1_decoded[31], rs2_decoded[31], rd_val, rs1_val_internal, rs2_val_internal);

endmodule

