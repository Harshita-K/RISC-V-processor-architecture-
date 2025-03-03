module alu_control (
    input [31:0] instruction,
    input [1:0] alu_op,
    output reg [3:0] alu_control_signal,
    output reg invFunc  // New flag for invalid function field
);

    wire [9:0] funct7_func3;
    assign funct7_func3 = {instruction[31:25], instruction[14:12]};

    always @(*) begin
        invFunc = 0;  // Default: valid function

        if (alu_op == 2'b00) 
            alu_control_signal = 4'b0010; // Load/Store (ADD)
        else if (alu_op == 2'b01) 
            alu_control_signal = 4'b0110; // Branch (SUB)
        else if (alu_op == 2'b10) begin
            case (funct7_func3)
                10'b0000000000: alu_control_signal = 4'b0010; // ADD
                10'b0100000000: alu_control_signal = 4'b0110; // SUB
                10'b0000000110: alu_control_signal = 4'b0001; // OR
                10'b0000000111: alu_control_signal = 4'b0011; // AND
                default: begin
                    alu_control_signal = 4'bxxxx; // Undefined operation
                    invFunc = 1;  // Set invalid function flag
                end
            endcase
        end else begin
            alu_control_signal = 4'bxxxx; // Undefined ALUOp
            invFunc = 1;  // Set invalid function flag
        end
    end
endmodule
