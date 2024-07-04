`define XLEN 32
`define REG_SELECT_LEN 5
`define BUS_HI_Z `XLEN'hzzzzzzzz
`define SELECT_HI_Z `REG_SELECT_LEN'bzzzzz

module lui (
    input  logic             clk,
    input  logic             enable_n,

    input  logic [`XLEN-1:0] instruction,

    output logic [`REG_SELECT_LEN-1:0] output_register,
    output logic [`XLEN-1:0] output_register_data
);

    always_comb begin
        if (!enable_n) begin

            output_register = instruction[11:7];
            output_register_data = {instruction[31:12], 3'h000};
        end else begin

            output_register = `SELECT_HI_Z;
            output_register_data = `BUS_HI_Z;
        end
    end

endmodule

