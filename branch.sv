`define XLEN 32
`define REG_SELECT_LEN 5
`define BUS_HI_Z `XLEN'hzzzzzzzz
`define SELECT_HI_Z `REG_SELECT_LEN'bzzzzz

module branch (
    input  logic             clk,
    input  logic             enable_n,

    input  logic [`XLEN-1:0] instruction,
    input  logic [`XLEN-1:0] program_counter,

    output logic [`REG_SELECT_LEN-1:0] register_1,
    output logic [`REG_SELECT_LEN-1:0] register_2,
    input  logic [`XLEN-1:0]           register_data_1,
    input  logic [`XLEN-1:0]           register_data_2,

    output logic [`XLEN-1:0] compare_data_1,
    output logic [`XLEN-1:0] compare_data_2,
    input  logic [`XLEN-1:0] alu_out,

    output logic             load_new_program_counter;
    output logic [`XLEN-1:0] new_program_counter,
);

    logic compare_success;
    logic jump;
    logic [2:0] alu_op;

    always @(posedge clk) begin
        if (!enable_n) begin
            register_1 <= instruction[12:8];
            register_2 <= instruction[17:13];
        end else begin
            register_1 <= `HI_Z;
            register_2 <= `HI_Z;
        end
    end

    always_comb begin
        if (!enable_n) begin
            compare_data_1 = register_data_1;
            compare_data_2 = register_data_2;

            // uhh black magic fuckery, hope i dont have to debug this
            alu_op = {~instruction[14], instruction[14], instruction[13]};
            load_new_program_counter = |alu_out ^ instruction[12];

        end else begin
            compare_data_1 = `BUS_HI_Z;
            compare_data_2 = `BUS_HI_Z;
            load_new_program_counter = 1'bz;
        end
    end

endmodule

