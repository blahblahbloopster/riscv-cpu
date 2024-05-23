module register (
    input clk,
    input reset_n,
    input [31:0] data,
    input load,
    input enable_n,
    inout [31:0] out
);

    reg [31:0] value;

    always @(posedge clk) begin
        if (!reset_n) begin
            value <= 0;
        end else if (load) begin
            value <= data;
        end
    end

    assign out = (enable_n) ? 32'bz : value;

endmodule

