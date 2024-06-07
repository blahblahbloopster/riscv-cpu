`define OPCODE_LEN 7
`define ENABLED  1'b0
`define DISABLED 1'b1

`define LUI     7b'0110111
`define AUIPC   7b'0010111
`define JAL     7b'1101111
`define JALR    7b'1100111
`define BRANCH  7b'1100011
`define STORE   7b'0000011
`define LOAD    7b'0100011
`define ALU_IMM 7b'0010011
`define ALU_REG 7b'0110011
`define FENCE   7b'0001111
`define SYS     7b'1110011

module enable_control (
    input logic [`OPCODE_LEN-1:0] opcode,
    output logic enable_alu,
    output logic enable_branch,
    output logic enable_load,
    output logic enable_store,
    output logic enable_register_array,
    output logic enable_program_counter
);

    always_comb begin
        case(opcode)
            `LUI: begin
                enable_alu             = `DISABLED;
                enable_branch          = `DISABLED;
                enable_load            = `DISABLED;
                enable_store           = `DISABLED;
                enable_register_array  = `ENABLED;
                enable_program_counter = `DISABLED;
            end
            `AUIPC: begin
                enable_alu             = `ENABLED;
                enable_branch          = `DISABLED;
                enable_load            = `DISABLED;
                enable_store           = `DISABLED;
                enable_register_array  = `ENABLED;
                enable_program_counter = `ENABLED;
            end
            `JAL: begin
                enable_alu             = `ENABLED;
                enable_branch          = `DISABLED;
                enable_load            = `DISABLED;
                enable_store           = `DISABLED;
                enable_register_array  = `ENABLED;
                enable_program_counter = `ENABLED;
            end
            `JALR: begin
                enable_alu             = `ENABLED;
                enable_branch          = `DISABLED;
                enable_load            = `DISABLED;
                enable_store           = `DISABLED;
                enable_register_array  = `ENABLED;
                enable_program_counter = `ENABLED;
            end
            `BRANCH: begin
                enable_alu             = `ENABLED;
                enable_branch          = `ENABLED;
                enable_load            = `DISABLED;
                enable_store           = `DISABLED;
                enable_register_array  = `ENABLED;
                enable_program_counter = `ENABLED;
            end
            `STORE: begin
                enable_alu             = `ENABLED;
                enable_branch          = `DISABLED;
                enable_load            = `DISABLED;
                enable_store           = `ENABLED;
                enable_register_array  = `ENABLED;
                enable_program_counter = `DISABLED;
            end
            `LOAD: begin
                enable_alu             = `ENABLED;
                enable_branch          = `DISABLED;
                enable_load            = `ENABLED;
                enable_store           = `DISABLED;
                enable_register_array  = `ENABLED;
                enable_program_counter = `DISABLED;
            end
            `ALU_IMM: begin
                enable_alu             = `ENABLED;
                enable_branch          = `DISABLED;
                enable_load            = `DISABLED;
                enable_store           = `DISABLED;
                enable_register_array  = `ENABLED;
                enable_program_counter = `DISABLED;
            end
            `ALU_REG: begin
                enable_alu             = `ENABLED;
                enable_branch          = `DISABLED;
                enable_load            = `DISABLED;
                enable_store           = `DISABLED;
                enable_register_array  = `ENABLED;
                enable_program_counter = `DISABLED;
            end
            `FENCE: begin
                enable_alu             = `DISABLED;
                enable_branch          = `DISABLED;
                enable_load            = `DISABLED;
                enable_store           = `DISABLED;
                enable_register_array  = `DISABLED;
                enable_program_counter = `DISABLED;
            end
            `SYS: begin
                enable_alu             = `DISABLED;
                enable_branch          = `DISABLED;
                enable_load            = `DISABLED;
                enable_store           = `DISABLED;
                enable_register_array  = `DISABLED;
                enable_program_counter = `DISABLED;
            end
        endcase
    end

endmodule

