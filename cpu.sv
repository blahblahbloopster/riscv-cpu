`define XLEN 32
`define REG_SELECT_LEN 5

module cpu (
    input logic clk,
    input logic reset_n,
);

    tri logic [`XLEN-1:0] instruction;
    
    tri logic             alu_enable_n;
    tri logic [2:0]       alu_opcode;
    tri logic             alu_signal;
    tri logic [`XLEN-1:0] alu_a;
    tri logic [`XLEN-1:0] alu_b;
    tri logic [`XLEN-1:0] alu_result;

    tri logic             branch_enable_n;
    tri logic [`XLEN-1:0] branch_register_1;
    tri logic [`XLEN-1:0] branch_register_2;
    tri logic [`XLEN-1:0] branch_register_data_1;
    tri logic [`XLEN-1:0] branch_register_data_2;
    tri logic [`XLEN-1:0] branch_compare_data_1;
    tri logic [`XLEN-1:0] branch_compare_data_2;
    tri logic [`XLEN-1:0] branch_alu_out;

    tri logic             pc_load;
    tri logic [`XLEN-1:0] pc_new_address;
    tri logic [`XLEN-1:0] pc_address;

    tri logic                       reg_array_enable_n;
    tri logic [`REG_SELECT_LEN-1:0] reg_array_store;
    tri logic [`REG_SELECT_LEN-1:0] reg_array_enable_a;
    tri logic [`REG_SELECT_LEN-1:0] reg_array_enable_b;
    tri logic [`XLEN-1:0]           reg_array_store_value;
    tri logic [`XLEN-1:0]           reg_array_a_bus;
    tri logic [`XLEN-1:0]           reg_array_b_bus;

    alu alu (
        .enable_n(alu_enable_n),
        .opcode(alu_opcode),
        .signal(alu_signal),
        .a(alu_a),
        .b(alu_b),
        .result(alu_result),
    );

    branch branch (
        .clk(clk),
        .enable_n(branch_enable_n),
        .instruction(instruction),
        .program_counter(program_counter),
        .register_1(branch_register_1),
        .register_2(branch_register_2),
        .register_data_1(branch_register_data_1),
        .register_data_2(branch_register_data_2),
        .compare_data_1(branch_compare_data_1),
        .compare_data_2(branch_compare_data_2),
        .compare_result(branch_compare_result),
    );

    program_counter program_counter (
        .clk(clk),
        .reset_n(reset_n),
        .load_new_address(pc_load),
        .new_address(pc_new_address),
        .address(pc_address),
    );

    register_array register_array (
        .clk(clk),
        .reset_n(reset_n),
        .enable_n(reg_array_enable_n),
        .store(reg_array_store),
        .enable_a(reg_array_enable_a),
        .enable_b(reg_array_enable_b),
        .store_value(reg_array_store_value),
        .a_bus(reg_array_a_bus),
        .b_bus(reg_array_b_bus),
    );

endmodule

