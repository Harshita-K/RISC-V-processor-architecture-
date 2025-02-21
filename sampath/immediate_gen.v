module ImmGen (
    input [31:0] instruction,
    output reg [63:0] immediate
);
    always @(*) begin
        case (instruction[6:0])
            7'b0000011, // Load (I-type)
            7'b0010011: // ALU Immediate (I-type)
                immediate = {{52{instruction[31]}}, instruction[31:20]};

            7'b0100011: // Store (S-type)
                immediate = {{52{instruction[31]}}, instruction[31:25], instruction[11:7]};

            7'b1100011: // Branch (B-type)
                immediate = {{51{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};

            7'b1101111: // JAL (J-type)
                immediate = {{43{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};

            7'b1100111: // JALR (I-type, treated like Load)
                immediate = {{52{instruction[31]}}, instruction[31:20]};

            7'b0110111, // LUI (U-type)
            7'b0010111: // AUIPC (U-type)
                immediate = {{32{instruction[31]}}, instruction[31:12], 12'b0};

            default: // Default case to avoid latching
                immediate = 64'd0;
        endcase
    end
endmodule
