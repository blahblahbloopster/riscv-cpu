`define XLEN 32
`define REG_SELECT_LEN 5
`define BUS_HI_Z `XLEN'hzzzzzzzz
`define SELECT_HI_Z `REG_SELECT_LEN'bzzzzz

module branch (
    input  logic clk,
    input  logic enable_n,

    input  logic [`XLEN-1:0] instruction,
    input  logic [`XLEN-1:0] program_counter,

    output logic [`REG_SELECT_LEN-1:0] register_1,
    output logic [`REG_SELECT_LEN-1:0] register_2,
    input  logic [`XLEN-1:0] register_data_1,
    input  logic [`XLEN-1:0] register_data_2,

    output logic [`XLEN-1:0] alu_a,
    output logic [`XLEN-1:0] alu_b,
    output logic [2:0]       alu_op,
    input  logic [`XLEN-1:0] alu_out,

    output logic             load_new_program_counter,
    output logic [`XLEN-1:0] new_program_counter
);

    logic [12:0] offset;

    always @(posedge clk) begin
        if (!enable_n) begin
            register_1 <= instruction[19:15];
            register_2 <= instruction[24:20];
        end else begin
            register_1 <= `BUS_HI_Z;
            register_2 <= `BUS_HI_Z;
        end
    end

    always_comb begin
        if (!enable_n) begin
            alu_a = register_data_1;
            alu_b = register_data_2;

            alu_op = {~instruction[14], instruction[14], instruction[13]};
            load_new_program_counter = |alu_out ^ instruction[12];

            offset = {instruction[31], instruction[7], instruction[30:25],
                      instruction[11:8]};
            new_program_counter = program_counter + offset;
        end else begin
            alu_a = `BUS_HI_Z;
            alu_b = `BUS_HI_Z;
            alu_op = 3'bzzz;
            load_new_program_counter = 1'bz;
            new_program_counter = `BUS_HI_Z;
        end
    end

endmodule

