
module ALUControl (
    input [31:0] instruction,
    input [1:0] ALUOp,
    output reg [3:0] ALU_control_signal
);
    
    always @(*) begin
        if (ALUOp == 2'b00)
            ALU_control_signal = 4'b0010;
        else if (ALUOp == 2'b01)
            ALU_control_signal = 4'b0110;
        else if (ALUOp == 2'b10) begin
            case ({instruction[31:25], instruction[14:12]})
                10'b0000000000: ALU_control_signal = 4'b0010;
                10'b0100000000: ALU_control_signal = 4'b0110;
                10'b0000000001: ALU_control_signal = 4'b0001;
                10'b0000000010: ALU_control_signal = 4'b0111;
                10'b0000000011: ALU_control_signal = 4'b1100;
                10'b0000000100: ALU_control_signal = 4'b0000;
                10'b0000000101: ALU_control_signal = 4'b0100;
                10'b0100000101: ALU_control_signal = 4'b1101;
                10'b0000000110: ALU_control_signal = 4'b0001;
                10'b0000000111: ALU_control_signal = 4'b0011;
                default: ALU_control_signal = 4'b1111;
            endcase
        end else 
            ALU_control_signal = 4'b1111;
    end
endmodule

