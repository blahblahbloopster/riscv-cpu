module alu (input  logic [3:0]  opcode,
            input  logic [31:0] a, b,
            output logic [31:0] d);

    logic [4:0] shift;
     
    always_comb begin
	shift = b[4:0];
        case(opcode[2:0])
            0: d = a + (opcode[3] ? -b : b);
            1: d = a << shift;
            2: d = $signed(a) < $signed(b) ? 32'h00000001 : 32'h00000000;
            3: d = a < b ? 32'h00000001 : 32'h00000000;
            4: d = a ^ b;
            5: d = opcode[3] ? ($signed(a) >>> shift) : ($signed(a) >> shift);
            6: d = a | b;
            7: d = a & b;
        endcase;
    end;

endmodule

