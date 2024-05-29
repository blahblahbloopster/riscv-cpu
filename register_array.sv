module register_array (
    input logic clk,
    input logic reset_n,
    input logic [4:0] select,
    input logic [4:0] enable_a,
    input logic [4:0] enable_b,
    input logic [31:0] store_data,
    output logic [31:0] a_bus,
    output logic [31:0] b_bus
);

    logic [31:0] enable_a_decoded;
    logic [31:0] enable_b_decoded;
    logic [31:0] store_decoded;

    always_comb begin
        enable_a_decoded = 31'b0;
        enable_b_decoded = 31'b0;
        store_decoded = 31'b0;

        enable_a_decoded[enable_a] = 1'b1;
        enable_b_decoded[enable_b] = 1'b1;
        store_decoded[store_data] = 1'b1;
    end

    register R0(clk, reset_n, 0, 1, enable_a_decoded[0], enable_b_decoded[0], a_bus, b_bus);
    register R1(clk, reset_n, data, store_decoded[1], enable_a_decoded[1], enable_b_decoded[1], a_bus, b_bus);
    register R2(clk, reset_n, data, store_decoded[2], enable_a_decoded[2], enable_b_decoded[2], a_bus, b_bus);
    register R3(clk, reset_n, data, store_decoded[3], enable_a_decoded[3], enable_b_decoded[3], a_bus, b_bus);
    register R4(clk, reset_n, data, store_decoded[4], enable_a_decoded[4], enable_b_decoded[4], a_bus, b_bus);
    register R5(clk, reset_n, data, store_decoded[5], enable_a_decoded[5], enable_b_decoded[5], a_bus, b_bus);
    register R6(clk, reset_n, data, store_decoded[6], enable_a_decoded[6], enable_b_decoded[6], a_bus, b_bus);
    register R7(clk, reset_n, data, store_decoded[7], enable_a_decoded[7], enable_b_decoded[7], a_bus, b_bus);
    register R8(clk, reset_n, data, store_decoded[8], enable_a_decoded[8], enable_b_decoded[8], a_bus, b_bus);
    register R9(clk, reset_n, data, store_decoded[9], enable_a_decoded[9], enable_b_decoded[9], a_bus, b_bus);
    register R10(clk, reset_n, data, store_decoded[10], enable_a_decoded[10], enable_b_decoded[10], a_bus, b_bus);
    register R11(clk, reset_n, data, store_decoded[11], enable_a_decoded[11], enable_b_decoded[11], a_bus, b_bus);
    register R12(clk, reset_n, data, store_decoded[12], enable_a_decoded[12], enable_b_decoded[12], a_bus, b_bus);
    register R13(clk, reset_n, data, store_decoded[13], enable_a_decoded[13], enable_b_decoded[13], a_bus, b_bus);
    register R14(clk, reset_n, data, store_decoded[14], enable_a_decoded[14], enable_b_decoded[14], a_bus, b_bus);
    register R15(clk, reset_n, data, store_decoded[15], enable_a_decoded[15], enable_b_decoded[15], a_bus, b_bus);
    register R16(clk, reset_n, data, store_decoded[16], enable_a_decoded[16], enable_b_decoded[16], a_bus, b_bus);
    register R17(clk, reset_n, data, store_decoded[17], enable_a_decoded[17], enable_b_decoded[17], a_bus, b_bus);
    register R18(clk, reset_n, data, store_decoded[18], enable_a_decoded[18], enable_b_decoded[18], a_bus, b_bus);
    register R19(clk, reset_n, data, store_decoded[19], enable_a_decoded[19], enable_b_decoded[19], a_bus, b_bus);
    register R20(clk, reset_n, data, store_decoded[20], enable_a_decoded[20], enable_b_decoded[20], a_bus, b_bus);
    register R21(clk, reset_n, data, store_decoded[21], enable_a_decoded[21], enable_b_decoded[21], a_bus, b_bus);
    register R22(clk, reset_n, data, store_decoded[22], enable_a_decoded[22], enable_b_decoded[22], a_bus, b_bus);
    register R23(clk, reset_n, data, store_decoded[23], enable_a_decoded[23], enable_b_decoded[23], a_bus, b_bus);
    register R24(clk, reset_n, data, store_decoded[24], enable_a_decoded[24], enable_b_decoded[24], a_bus, b_bus);
    register R25(clk, reset_n, data, store_decoded[25], enable_a_decoded[25], enable_b_decoded[25], a_bus, b_bus);
    register R26(clk, reset_n, data, store_decoded[26], enable_a_decoded[26], enable_b_decoded[26], a_bus, b_bus);
    register R27(clk, reset_n, data, store_decoded[27], enable_a_decoded[27], enable_b_decoded[27], a_bus, b_bus);
    register R28(clk, reset_n, data, store_decoded[28], enable_a_decoded[28], enable_b_decoded[28], a_bus, b_bus);
    register R29(clk, reset_n, data, store_decoded[29], enable_a_decoded[29], enable_b_decoded[29], a_bus, b_bus);
    register R30(clk, reset_n, data, store_decoded[30], enable_a_decoded[30], enable_b_decoded[30], a_bus, b_bus);
    register R31(clk, reset_n, data, store_decoded[31], enable_a_decoded[31], enable_b_decoded[31], a_bus, b_bus);

endmodule

