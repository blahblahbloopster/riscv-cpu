`define XLEN 32

module register (
    input  logic             clk,
    input  logic             reset_n,
    input  logic             store,
    input  logic             enable_a,
    input  logic             enable_b,
    input  logic [`XLEN-1:0] data,
    output tri   [`XLEN-1:0] a_out,
    output tri   [`XLEN-1:0] b_out
);

    reg [`XLEN-1:0] value = 0;

    always @(posedge clk) begin
        if (!reset_n) begin
            value <= `XLEN'b0;
        end else if (store) begin
            value <= data;
        end
    end

    assign a_out = (enable_a) ? value : `XLEN'bz;
    assign b_out = (enable_b) ? value : `XLEN'bz;

endmodule

