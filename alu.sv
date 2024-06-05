`define XLEN 32
`define FALSE `XLEN'h00000000
`define TRUE  `XLEN'h00000001

module alu (
    input  logic             enable_n,
    input  logic [2:0]       opcode,
    input  logic             signal,
    input  logic [`XLEN-1:0] a,
    input  logic [`XLEN-1:0] b,
    output logic [`XLEN-1:0] result,
);

    logic [4:0] shift;
     
    always_comb begin
        shift = !enable_n ? b[4:0] : 5'bzzzzz;
        if (!enable_n) begin
            case(opcode)
                0: result = a + (signal ? -b : b);
                1: result = a << shift;
                2: result = $signed(a) < $signed(b) ? `TRUE : `FALSE;
                3: result = a < b ? `TRUE : `FALSE;
                4: result = a ^ b;
                5: result = signal ? ($signed(a) >>> shift)
                                   : ($signed(a) >> shift);
                6: result = a | b;
                7: result = a & b;
            endcase
        end else begin
            result = `XLEN'hzzzzzzzz;
        end
    end

endmodule

