`define XLEN 32

module zero_register (
    input  logic                clk,
    input  logic                enable_a,
    input  logic                enable_b,
    output tri [`XLEN-1:0]      a_out,
    output tri [`XLEN-1:0]      b_out
);

    reg [`XLEN-1:0] value = 0;

    assign a_out = (enable_a) ? value : `XLEN'bz;
    assign b_out = (enable_b) ? value : `XLEN'bz;

endmodule

