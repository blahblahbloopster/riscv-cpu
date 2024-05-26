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
        store_decoded[store] = 1'b1;
    end

    register R0(clk, reset_n, 0, 1, enable_a[0], enable_b[0], a_bus, b_bus);
    register R1(clk, reset_n, data, store[1], enable_a[1], enable_b[1], a_bus, b_bus);
    register R2(clk, reset_n, data, store[2], enable_a[2], enable_b[2], a_bus, b_bus);
    register R3(clk, reset_n, data, store[3], enable_a[3], enable_b[3], a_bus, b_bus);
    register R4(clk, reset_n, data, store[4], enable_a[4], enable_b[4], a_bus, b_bus);
    register R5(clk, reset_n, data, store[5], enable_a[5], enable_b[5], a_bus, b_bus);
    register R6(clk, reset_n, data, store[6], enable_a[6], enable_b[6], a_bus, b_bus);
    register R7(clk, reset_n, data, store[7], enable_a[7], enable_b[7], a_bus, b_bus);
    register R8(clk, reset_n, data, store[8], enable_a[8], enable_b[8], a_bus, b_bus);
    register R9(clk, reset_n, data, store[9], enable_a[9], enable_b[9], a_bus, b_bus);
    register R10(clk, reset_n, data, store[10], enable_a[10], enable_b[10], a_bus, b_bus);
    register R11(clk, reset_n, data, store[11], enable_a[11], enable_b[11], a_bus, b_bus);
    register R12(clk, reset_n, data, store[12], enable_a[12], enable_b[12], a_bus, b_bus);
    register R13(clk, reset_n, data, store[13], enable_a[13], enable_b[13], a_bus, b_bus);
    register R14(clk, reset_n, data, store[14], enable_a[14], enable_b[14], a_bus, b_bus);
    register R15(clk, reset_n, data, store[15], enable_a[15], enable_b[15], a_bus, b_bus);
    register R16(clk, reset_n, data, store[16], enable_a[16], enable_b[16], a_bus, b_bus);
    register R17(clk, reset_n, data, store[17], enable_a[17], enable_b[17], a_bus, b_bus);
    register R18(clk, reset_n, data, store[18], enable_a[18], enable_b[18], a_bus, b_bus);
    register R19(clk, reset_n, data, store[19], enable_a[19], enable_b[19], a_bus, b_bus);
    register R20(clk, reset_n, data, store[20], enable_a[20], enable_b[20], a_bus, b_bus);
    register R21(clk, reset_n, data, store[21], enable_a[21], enable_b[21], a_bus, b_bus);
    register R22(clk, reset_n, data, store[22], enable_a[22], enable_b[22], a_bus, b_bus);
    register R23(clk, reset_n, data, store[23], enable_a[23], enable_b[23], a_bus, b_bus);
    register R24(clk, reset_n, data, store[24], enable_a[24], enable_b[24], a_bus, b_bus);
    register R25(clk, reset_n, data, store[25], enable_a[25], enable_b[25], a_bus, b_bus);
    register R26(clk, reset_n, data, store[26], enable_a[26], enable_b[26], a_bus, b_bus);
    register R27(clk, reset_n, data, store[27], enable_a[27], enable_b[27], a_bus, b_bus);
    register R28(clk, reset_n, data, store[28], enable_a[28], enable_b[28], a_bus, b_bus);
    register R29(clk, reset_n, data, store[29], enable_a[29], enable_b[29], a_bus, b_bus);
    register R30(clk, reset_n, data, store[30], enable_a[30], enable_b[30], a_bus, b_bus);
    register R31(clk, reset_n, data, store[31], enable_a[31], enable_b[31], a_bus, b_bus);

endmodule

