`define XLEN 32
`define CODE_START `XLEN'h80000000
`define PC_STEP    `XLEN'h00000004

module program_counter (
    input  logic             clk,
    input  logic             reset_n,
    input  logic             enable_n,

    input  logic             load_new_address,
    input  logic [`XLEN-1:0] new_address,

    output logic [`XLEN-1:0] address
);

    reg [`XLEN-1:0] value = `CODE_START;

    always @(posedge clk) begin
        if (!enable_n) begin
            if (!reset_n) begin
                value <= `CODE_START;
            end else if (load_new_address) begin
                value <= new_address;
            end else begin
                value <= value + `PC_STEP;
            end
        end
    end

    assign address = enable_n ? `XLEN'hzzzzzzzz : value;

endmodule

