module register (
    input clk,
    input reset_n,
    input [31:0] data,
    input store,
    input enable_a,
    input enable_b,
    inout [31:0] a_out,
    inout [31:0] b_out
);

    reg [31:0] value;

    always @(posedge clk) begin
        if (!reset_n) begin
            value <= 0;
        end else if (store) begin
            value <= data;
        end
    end

    assign a_out = (enable_a) ? value : 32'bz;
    assign b_out = (enable_b) ? value : 32'bz;

endmodule

