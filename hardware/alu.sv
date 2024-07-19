`define XLEN 32

`define FALSE `XLEN'h00000000
`define TRUE  `XLEN'h00000001

`define ALU_ADD  3'b000
`define ALU_SLL  3'b001
`define ALU_SLT  3'b010
`define ALU_SLTU 3'b011
`define ALU_XOR  3'b100
`define ALU_SR   3'b101
`define ALU_OR   3'b110
`define ALU_AND  3'b111

module alu (
    input  logic                enable_n,
    input  logic [2:0]          funct3,
    input  logic                alt_funct,
    input  logic [`XLEN-1:0]    a,
    input  logic [`XLEN-1:0]    b,
    output logic [`XLEN-1:0]    result
);

    logic [4:0] shamt;
     
    always_comb begin
        if (!enable_n) begin
            shamt = b[4:0];
            case(funct3)
                `ALU_ADD:  result = a + (alt_funct ? -b : b);
                `ALU_SLL:  result = a << shamt;
                `ALU_SLT:  result = $signed(a) < $signed(b) ? `TRUE : `FALSE;
                `ALU_SLTU: result = a < b ? `TRUE : `FALSE;
                `ALU_XOR:  result = a ^ b;
                `ALU_SR:   result = alt_funct ? ($signed(a) >>> shamt)
                                              : ($signed(a) >> shamt);
                `ALU_OR:   result = a | b;
                `ALU_AND:  result = a & b;
            endcase
        end else begin
            shamt = 5'bzzzzz;
            result = `XLEN'hzzzzzzzz;
        end
    end

endmodule

