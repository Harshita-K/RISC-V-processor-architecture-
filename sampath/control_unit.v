module ControlUnit (opcode, RegWrite, ALUSrc, MemRead, MemWrite, Branch, ALUOp);

    input [6:0] opcode;
    output RegWrite, ALUSrc, MemRead, MemWrite, Branch;
    output [1:0] ALUOp;

    assign RegWrite = 0;
    assign ALUSrc   = 0;
    assign MemRead  = 0;
    assign MemWrite = 0;
    assign Branch   = 0;
    assign ALUOp    = 2'b00;

    case (opcode)
        7'b0110011: begin  // R-type
            RegWrite = 1;
            ALUOp    = 2'b10;
        end
        7'b0000011: begin  // Load (LW)
            RegWrite = 1;
            ALUSrc   = 1;
            MemRead  = 1;
        end
        7'b0100011: begin  // Store (SW)
            ALUSrc   = 1;
            MemWrite = 1;
        end
        7'b1100011: begin  // Branch (BEQ)
            Branch   = 1;
            ALUOp    = 2'b01;
        end
    endcase
endmodule
