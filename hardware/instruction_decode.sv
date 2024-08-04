`define XLEN        32
`define REG_LEN     5

`define OP_LUI      7'b0110111,
`define OP_AUIPC    7'b0010111,
`define OP_JAL      7'b1101111,
`define OP_JALR     7'b1100111,
`define OP_BRANCH   7'b1100011,
`define OP_LOAD     7'b0000011,
`define OP_STORE    7'b0100011,
`define OP_ALU_IMM  7'b0010011,
`define OP_ALU_REG  7'b0110011,
`define OP_FENCE    7'b0001111,
`define OP_SYS      7'b1110011,

typedef enum {
    R_TYPE,
    I_TYPE,
    S_TYPE,
    B_TYPE,
    U_TYPE,
    J_TYPE,
} InstructionType;

`define Z_3         3'bzzz
`define Z_5         5'bzzzzz
`define Z_7         7'bzzzzzzz
`define Z_12        12'hzzz
`define Z_20        20'hzzzzz

module instruction_decode (
    input  logic [`XLEN-1:0]        instruction,
                                
    output logic [6:0]              opcode,

    output logic [2:0]              funct3,
    output logic [6:0]              funct7,
                                
    output logic [`REG_LEN-1:0]     rs1,
    output logic [`REG_LEN-1:0]     rs2,
    output logic [`REG_LEN-1:0]     rd,
                                
    output logic [11:0]             imm12,
    output logic [19:0]             imm20,
);

    logic [6:0] opcode = instruction[6:0];
    assign funct3 = instruction[14:12];
    InstructionType instruction_type;

    case (opcode)
        `OP_ALU_REG: begin
            instruction_type = R_TYPE;
        end
        `OP_LOAD, `OP_JALR, `OP_ALU_IMM, `OP_FENCE, `OP_SYS: begin
            instruction_type = I_TYPE;
        end
        `OP_STORE: begin
            instruction_type = S_TYPE;
        end
        `OP_BRANCH: begin
            instruction_type = B_TYPE;
        end
        `OP_LUI, `OP_AUIPC: begin
            instruction_type = U_TYPE;
        end
        `OP_JAL: begin
            instruction_type = J_TYPE;
        end
        default: begin
            instruction_type = INVALID;
        end
    endcase

    case (instruction_type)
        R_TYPE: begin
            funct7  = instruction[31:25];
            rs1     = instruction[19:15];
            rs2     = instruction[24:20];
            rd      = instruction[11:7];
            imm12   = `Z_12;
            imm20   = `Z_20;
        end
        I_TYPE: begin
            funct7  = `Z_7;
            rs1     = instruction[19:15];
            rs2     = `Z_5;
            rd      = instruction[11:7];
            imm12   = instruction[31:20];
            imm20   = `Z_20;
        end
        S_TYPE: begin
            funct7  = `Z_7;
            rs1     = instruction[19:15];
            rs2     = instruction[24:20];
            rd      = `Z_5;
            imm12   = instruction[11:7] | instruction[31:25] << `REG_LEN;
            imm20   = `Z_20;
        end
        B_TYPE: begin
            funct7  = `Z_7;
            rs1     = instruction[19:15];
            rs2     = instruction[24:20];
            rd      = `Z_5;
            imm12   = instruction[11:8]
                    | instruction[30:25] << 4
                    | instruction[7] << 10
                    | instruction[31] << 11;
            imm20   = `Z_20;
        end
        U_TYPE: begin
            funct7  = `Z_7;
            rs1     = `Z_5;
            rs2     = `Z_5;
            rd      = instruction[11:7];
            imm12   = `Z_12;
            imm20   = instruction[31:12];
        end
        J_TYPE: begin
            funct7  = `Z_7;
            rs1     = `Z_5;
            rs2     = `Z_5;
            rd      = instruction[11:7];
            imm12   = `Z_12;
            imm20   = instruction[30:21]
                    | instruction[20] << 10
                    | instruction[19:12] << 11
                    | instruction[31] << 19;
        end
        INVALID: begin
            funct7  = `Z_7;
            rs1     = `Z_5;
            rs2     = `Z_5;
            rd      = `Z_5;
            imm12   = `Z_12;
            imm20   = `Z_20;
        end
    endcase

endmodule
