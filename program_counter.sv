`define XLEN 32
`define CODE_START `XLEN'h8000
`define PC_STEP    `XLEN'h0004

module program_counter (
    input  logic             clk,
    input  logic             reset_n,
    input  logic             enable_n,

    input  logic             load_new_address,
    input  logic [`XLEN-1:0] new_address,

    output logic [`XLEN-1:0] address,
);

    reg [`XLEN-1:0] value = 0;

    always @(posedge clk) begin
        if (!enable_n) begin
            if (!reset_n) begin
                value <= `CODE_START;
            end else if (load_new_address) begin
                value <= new_address;
            end else begin
                value <= value + `PC_STEP;
            end

        end else begin
            value <= `XLEN'hzzzzzzzz;
        end
    end

    assign address = value;

endmodule

