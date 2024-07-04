`define XLEN 32
`define DATA_START `XLEN'hc000_0000
`define CODE_START `XLEN'h8000_0000

typedef enum {
    BYTE,
    HALFWORD,
    WORD
} Width;

typedef enum {
    WRITING_0,
    WRITING_1,
    WRITING_2,
    WRITING_3,

    READING_0,
    READING_1,
    READING_2,
    READING_3,

    IDLE
} MemoryState;

typedef enum {
    FETCH_IDLE,
    FETCHING
} FetchState;

module memory(
    input logic clk,
    input logic [`XLEN-1:0] address_main,
    input logic [3:0] width,
    input logic read_request_main,
    input logic write_request_main,

    input logic [`XLEN-1:0] write_data_main,

    input logic [`XLEN-1:0] address_fetch,
    input logic fetch_request,

    output logic [`XLEN-1:0] data_main,
    output logic busy_main,
    
    output logic [31:0] data_fetch,
    output logic busy_fetch
);

    MemoryState state = IDLE;

    FetchState fetch_state = FETCH_IDLE;

    logic [15:0] main_addr, addr;
    logic [7:0] main_wdata, main_rdata;
    logic main_rden, main_wren;
    logic [`XLEN-1:0] wdata, read_data;

    main_memory main_memory(main_addr, clk, main_wdata, main_rden, main_wren, main_rden);

    logic [15:0] rom_addr;
    logic [`XLEN-1:0] rom_q;
    logic rom_rden;

    program_rom program_rom(rom_addr, clk, rom_rden, rom_q);
    
    always_ff @(posedge clk) begin
        case (state)
            IDLE: begin
                if (read_request_main) begin
                    // TODO: bounds check
                    read_data = 0;
                    main_rden = 1;
                    case (width)
                        BYTE: begin
                            state <= READING_0;
                            main_rden = 1;
                            addr = address_main - `DATA_START;
                            main_addr = address_main - `DATA_START;
                            busy_main = 1;
                        end
                        HALFWORD: begin
                            state <= READING_1;
                            main_rden = 1;
                            addr = address_main - `DATA_START;
                            main_addr = address_main - `DATA_START + 1;
                            busy_main = 1;
                        end
                        WORD: begin
                            state <= READING_3;
                            main_rden = 1;
                            addr = address_main - `DATA_START;
                            main_addr = address_main - `DATA_START + 3;
                            busy_main = 1;
                        end
                    endcase
                end else if (write_request_main) begin
                    case (width)
                        BYTE: begin
                            state <= WRITING_0;
                            main_wren = 1;
                            addr = address_main - `DATA_START;
                            main_addr = address_main - `DATA_START;
                        end
                        HALFWORD: begin
                            state <= WRITING_1;
                            main_wren = 1;
                            addr = address_main - `DATA_START;
                            main_addr = address_main - `DATA_START + 1;
                        end
                        WORD: begin
                            state <= WRITING_3;
                            main_wren = 1;
                            addr = address_main - `DATA_START;
                            main_addr = address_main - `DATA_START + 3;
                        end
                    endcase
                end else begin
                    main_wren = 0;
                    main_rden = 0;
                    busy_main = 0;
                end
            end
            WRITING_0: begin
                state <= IDLE;
                busy_main = 0;
                main_wren = 0;
            end
            WRITING_1: begin
                state <= WRITING_0;
                main_addr = addr;
                main_wren = 1;
                busy_main = 1;
                main_wdata = wdata[7:0];
            end
            WRITING_2: begin
                state <= WRITING_1;
                main_addr = addr + 1;
                main_wren = 1;
                busy_main = 1;
                main_wdata = wdata[15:8];
            end
            WRITING_3: begin
                state <= WRITING_2;
                main_addr = addr + 2;
                main_wren = 1;
                busy_main = 1;
                main_wdata = wdata[23:16];
            end

            READING_0: begin
                state <= IDLE;
                read_data[7:0] = main_rdata;
                main_rden = 0;
                busy_main = 0;
            end
            READING_1: begin
                state <= READING_0;
                read_data[15:8] = main_rdata;
                main_addr = addr;
                main_rden = 1;
                busy_main = 1;
            end
            READING_2: begin
                state <= READING_1;
                read_data[23:16] = main_rdata;
                main_addr = addr + 1;
                main_rden = 1;
                busy_main = 1;
            end
            READING_3: begin
                state <= READING_2;
                read_data[31:24] = main_rdata;
                main_addr = addr + 2;
                main_rden = 1;
                busy_main = 1;
            end
        endcase


        case (fetch_state)
            FETCH_IDLE: begin
                if (fetch_request) begin
                    busy_fetch <= 1;
                    rom_rden = 1;
                    rom_addr = (address_fetch - `CODE_START) / 4;
                end
            end
            FETCHING: begin
                busy_fetch <= 0;
                data_fetch = rom_q;
                rom_rden = 0;
            end
        endcase
    end
endmodule

