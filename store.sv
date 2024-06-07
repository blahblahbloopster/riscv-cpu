`define XLEN 32
`define REG_SELECT_LEN 5
`define BUS_HI_Z `XLEN'hzzzzzzzz
`define SELECT_HI_Z `REG_SELECT_LEN'bzzzzz

typedef enum {
    IDLE,
    WAITING
} StoreState;

module store(
    input logic clk,
    input logic enable_n,
    output logic [`REG_SELECT_LEN-1] register_1,
    output logic [`REG_SELECT_LEN-1] register_2,
    input logic [`XLEN-1:0] register_data_1,
    input logic [`XLEN-1:0] register_data_2,
    input logic [31:0] instruction,

    input logic memory_busy,

    output logic [`REG_SELECT_LEN-1] register_store,
    output logic [`XLEN-1] register_store_data,

    output logic [`XLEN-1:0] memory_address,
    output logic [3:0] memory_width,
    output logic memory_read_request,
    output logic memory_write_request,

    output logic busy,
);

    StoreState state = IDLE;

    logic [3:0] width;
    logic [11:0] offset;
    logic [`REG_SELECT_LEN-1:0] rs1, rs2;

    always_ff @(posedge clk) begin
        if (!enable_n) begin
            if (state == IDLE) begin
                busy = 1;
                state <= WAITING;

                // decode instruction
                width = instruction[14:12];
                rs1 = instruction[19:15];
                rs2 = instruction[24:20];
                offset[11:5] = instruction[31:25];
                offset[4:0] = instruction[11:7];

                register_1 = rs1;
                register_2 = rs2;

                memory_address = register_data_1 + $signed(offset);
                memory_write_request = 1;
                case (width)
                        3'b000: begin
                            // byte
                            memory_width = 1;
                        end
                        3'b001: begin
                            // halfword
                            memory_width = 2;
                        end
                        3'b010: begin
                            // word
                            memory_width = 4;
                        end
                    endcase
            end else begin
                if (!memory_busy) begin
                    // done writing, reset state and set busy to false
                    busy = 0;
                    state <= IDLE;
                end else begin
                    busy = 1;
                    register_store = 0;
                    register_1 = `SELECT_HI_Z;
                    register_2 = `SELECT_HI_Z;
                    register_store = `SELECT_HI_Z;
                    register_store_data = `BUS_HI_Z;
                    memory_address = `BUS_HI_Z;
                    memory_width = 4'bzzzz;
                    memory_read_request = 1'bz;
                end
                memory_write_request = 0;
            end
        end begin
            busy = 0;
            register_1 = `SELECT_HI_Z;
            register_2 = `SELECT_HI_Z;
            register_store = `SELECT_HI_Z;
            register_store_data = `BUS_HI_Z;
            memory_address = `BUS_HI_Z;
            memory_width = 4'bzzzz;
            memory_read_request = 1'bz;
            memory_write_request = 1'bz;

        end
    end
endmodule

