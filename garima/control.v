module Control(
    input wire [6:0] opcode,
    output reg Branch,
    output reg MemRead,
    output reg MemToReg,
    output reg [1:0] ALUOp,
    output reg MemWrite,
    output reg ALUSrc,
    output reg RegWrite
);
    always @(*) begin
        // Default values
        Branch    = 0;
        MemRead   = 0;
        MemToReg  = 0;
        ALUOp     = 2'b00;
        MemWrite  = 0;
        ALUSrc    = 0;
        RegWrite  = 0;

        case (opcode)
            7'b0110011: begin // R-type
                RegWrite = 1;
                ALUOp    = 2'b10;
            end
            7'b0000011: begin // LW
                MemRead   = 1;
                MemToReg  = 1;
                ALUSrc    = 1;
                RegWrite  = 1;
                ALUOp     = 2'b00;
            end
            7'b0100011: begin // SW
                MemWrite = 1;
                ALUSrc   = 1;
                ALUOp    = 2'b00;
            end
            7'b1100011: begin // BEQ
                Branch   = 1;
                ALUOp    = 2'b01;
            end
            7'b0010011: begin // I-type (ADDI, etc.)
                RegWrite = 1;
                ALUSrc   = 1;
                ALUOp    = 2'b00;
            end
            default: begin
                // No operation / default
            end
        endcase
    end
endmodule
