module ImmGen(
    input wire [31:0] instruction,
    output reg [31:0] imm
);
    wire [6:0] opcode = instruction[6:0];

    always @(*) begin
        case (opcode)
            // LW, I-type (ADDI, etc.)
            7'b0000011, // LW
            7'b0010011: // ADDI
            begin
                // I-type: imm[31:0] = sign-extend of instruction[31:20]
                imm = {{20{instruction[31]}}, instruction[31:20]};
            end

            // SW (S-type)
            7'b0100011: begin
                // S-type: imm = sign-extend of {instr[31:25], instr[11:7]}
                imm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            end

            // BEQ (B-type)
            7'b1100011: begin
                // B-type: imm = sign-extend of {instr[31], instr[7], instr[30:25], instr[11:8], 0}
                imm = {{20{instruction[31]}}, instruction[7], instruction[30:25],
                       instruction[11:8], 1'b0};
            end

            default: begin
                imm = 32'b0;  // for R-type or unrecognized instructions
            end
        endcase
    end
endmodule
