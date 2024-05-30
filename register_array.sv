`define XLEN 32
`define SELECT_LEN 5

module register_array (
    input  logic                   clk,
    input  logic                   reset_n,
    input  logic [`SELECT_LEN-1:0] store,
    input  logic [`SELECT_LEN-1:0] enable_a,
    input  logic [`SELECT_LEN-1:0] enable_b,
    input  logic [`XLEN-1:0]       store_value,
    output logic [`XLEN-1:0]       a_bus,
    output logic [`XLEN-1:0]       b_bus
);

    logic [`XLEN-1:0] enable_a_decoded;
    logic [`XLEN-1:0] enable_b_decoded;
    logic [`XLEN-1:0] store_decoded;

    tri [`XLEN-1:0] a_internal;
    tri [`XLEN-1:0] b_internal;

    always_comb begin
        store_decoded = `XLEN'b1 << store;
        enable_a_decoded = `XLEN'b1 << enable_a;
        enable_b_decoded = `XLEN'b1 << enable_b;
        a_bus = a_internal;
        b_bus = b_internal;
    end

    register R0(clk, reset_n, 1'b1, enable_a_decoded[0], enable_b_decoded[0], `XLEN'b0, a_internal, b_internal);
    register R1(clk, reset_n, store_decoded[1], enable_a_decoded[1], enable_b_decoded[1], store_value, a_internal, b_internal);
    register R2(clk, reset_n, store_decoded[2], enable_a_decoded[2], enable_b_decoded[2], store_value, a_internal, b_internal);
    register R3(clk, reset_n, store_decoded[3], enable_a_decoded[3], enable_b_decoded[3], store_value, a_internal, b_internal);
    register R4(clk, reset_n, store_decoded[4], enable_a_decoded[4], enable_b_decoded[4], store_value, a_internal, b_internal);
    register R5(clk, reset_n, store_decoded[5], enable_a_decoded[5], enable_b_decoded[5], store_value, a_internal, b_internal);
    register R6(clk, reset_n, store_decoded[6], enable_a_decoded[6], enable_b_decoded[6], store_value, a_internal, b_internal);
    register R7(clk, reset_n, store_decoded[7], enable_a_decoded[7], enable_b_decoded[7], store_value, a_internal, b_internal);
    register R8(clk, reset_n, store_decoded[8], enable_a_decoded[8], enable_b_decoded[8], store_value, a_internal, b_internal);
    register R9(clk, reset_n, store_decoded[9], enable_a_decoded[9], enable_b_decoded[9], store_value, a_internal, b_internal);
    register R10(clk, reset_n, store_decoded[10], enable_a_decoded[10], enable_b_decoded[10], store_value, a_internal, b_internal);
    register R11(clk, reset_n, store_decoded[11], enable_a_decoded[11], enable_b_decoded[11], store_value, a_internal, b_internal);
    register R12(clk, reset_n, store_decoded[12], enable_a_decoded[12], enable_b_decoded[12], store_value, a_internal, b_internal);
    register R13(clk, reset_n, store_decoded[13], enable_a_decoded[13], enable_b_decoded[13], store_value, a_internal, b_internal);
    register R14(clk, reset_n, store_decoded[14], enable_a_decoded[14], enable_b_decoded[14], store_value, a_internal, b_internal);
    register R15(clk, reset_n, store_decoded[15], enable_a_decoded[15], enable_b_decoded[15], store_value, a_internal, b_internal);
    register R16(clk, reset_n, store_decoded[16], enable_a_decoded[16], enable_b_decoded[16], store_value, a_internal, b_internal);
    register R17(clk, reset_n, store_decoded[17], enable_a_decoded[17], enable_b_decoded[17], store_value, a_internal, b_internal);
    register R18(clk, reset_n, store_decoded[18], enable_a_decoded[18], enable_b_decoded[18], store_value, a_internal, b_internal);
    register R19(clk, reset_n, store_decoded[19], enable_a_decoded[19], enable_b_decoded[19], store_value, a_internal, b_internal);
    register R20(clk, reset_n, store_decoded[20], enable_a_decoded[20], enable_b_decoded[20], store_value, a_internal, b_internal);
    register R21(clk, reset_n, store_decoded[21], enable_a_decoded[21], enable_b_decoded[21], store_value, a_internal, b_internal);
    register R22(clk, reset_n, store_decoded[22], enable_a_decoded[22], enable_b_decoded[22], store_value, a_internal, b_internal);
    register R23(clk, reset_n, store_decoded[23], enable_a_decoded[23], enable_b_decoded[23], store_value, a_internal, b_internal);
    register R24(clk, reset_n, store_decoded[24], enable_a_decoded[24], enable_b_decoded[24], store_value, a_internal, b_internal);
    register R25(clk, reset_n, store_decoded[25], enable_a_decoded[25], enable_b_decoded[25], store_value, a_internal, b_internal);
    register R26(clk, reset_n, store_decoded[26], enable_a_decoded[26], enable_b_decoded[26], store_value, a_internal, b_internal);
    register R27(clk, reset_n, store_decoded[27], enable_a_decoded[27], enable_b_decoded[27], store_value, a_internal, b_internal);
    register R28(clk, reset_n, store_decoded[28], enable_a_decoded[28], enable_b_decoded[28], store_value, a_internal, b_internal);
    register R29(clk, reset_n, store_decoded[29], enable_a_decoded[29], enable_b_decoded[29], store_value, a_internal, b_internal);
    register R30(clk, reset_n, store_decoded[30], enable_a_decoded[30], enable_b_decoded[30], store_value, a_internal, b_internal);
    register R31(clk, reset_n, store_decoded[31], enable_a_decoded[31], enable_b_decoded[31], store_value, a_internal, b_internal);

endmodule

