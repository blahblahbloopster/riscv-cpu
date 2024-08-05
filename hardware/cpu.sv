`define XLEN 32
`define REG_LEN 5

module cpu (
    input logic clk,
    input logic reset_n,
);

    tri0 logic [`XLEN-1:0]      instruction;

    tri0 logic [6:0]            opcode;
    tri0 logic [2:0]            funct3;
    tri0 logic [6:0]            funct7;
    tri0 logic [`REG_LEN-1:0]   rs1;
    tri0 logic [`REG_LEN-1:0]   rs2;
    tri0 logic [`REG_LEN-1:0]   rd;
    tri0 logic [12:0]           imm12;
    tri0 logic [19:0]           imm20;

    tri0 logic                  reg_array_enable_n;
    tri0 logic [`XLEN-1:0]      rs1_val;
    tri0 logic [`XLEN-1:0]      rs2_val;
    tri0 logic [`XLEN-1:0]      rd_val;

    tri0 logic                  alu_enable_n;
    tri0 logic                  alu_alt_funct;
    tri0 logic [`XLEN-1:0]      alu_a;
    tri0 logic [`XLEN-1:0]      alu_b;
    tri0 logic [`XLEN-1:0]      alu_result;

    tri0 logic                  branch_enable_n;
    tri0 logic                  branch;
    tri0 logic [`XLEN-1:0]      branch_pc;

    tri0 logic                  pc_load;
    tri0 logic [`XLEN-1:0]      pc_new_address;
    tri0 logic [`XLEN-1:0]      pc_address;

    memory memory (
        .clk(clk),
        .address_main(address_main),
        .width(width_main),
        .read_request_main(read_request_main),
        .write_request_main(write_request_main),
        .write_data_main(write_data_main),

        .address_fetch(address_fetch),
        .fetch_request(fetch_request),

        .data_main(data_main),
        .busy_main(busy_main),
        .data_fetch(data_fetch)
    );

    alu alu (
        .enable_n(alu_enable_n),
        .opcode(alu_opcode),
        .signal(alu_signal),
        .a(alu_a),
        .b(alu_b),
        .result(alu_result),
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
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .rd_val(rd_val),
        .rs1_val(rs1_val),
        .rs2_val(rs2_val),
    );

    branch branch (
        .clk(clk),
        .enable_n(branch_enable_n),
        .pc(program_counter),
        .rs1_val(rs1_val),
        .rs2_val(rs2_val),
        .funct3(funct3),
        .imm12(imm12),
        .alu_result(alu_result),
        .branch(branch),
        .branch_pc(branch_pc),
    );

    load load(
        .clk(clk),
        .enable_n(load_enable_n),
        .register_1(reg_array_enable_a),
        .register_2(reg_array_enable_b),
        .register_data_1(rs1_val),
        .register_data_2(rs2_val),
        .instruction(instruction),
        .memory_busy(busy_main),
        .register_store(reg_array_store),
        .register_store_data(reg_array_store_value),
        .memory_address(address_main),
        .memory_width(width_main),
        .memory_read_request(read_request_main),
        .memory_write_request(write_request_main),
        .busy(load_busy),
    );

    store store(
        .clk(clk),
        .enable_n(store_enable_n),
        .register_1(reg_array_enable_a),
        .register_2(reg_array_enable_b),
        .register_data_1(rs1_val),
        .register_data_2(rs2_val),
        .instruction(instruction),
        .memory_busy(busy_main),
        .register_store(reg_array_store),
        .register_store_data(reg_array_store_value),
        .memory_address(address_main),
        .memory_width(width_main),
        .memory_read_request(read_request_main),
        .memory_write_request(write_request_main),
        .busy(load_busy),
    );

endmodule

