module alu_control (instruction,alu_control_signal);

    input [31:0] instruction;
    output reg [3:0] alu_control_signal;
    reg [9:0] funct7_func3;
    
    always @(*) begin
        funct7_func3 = {instruction[31:25], instruction[14:12]};

        case (funct7_func3)
            10'b0000000000: alu_control_signal = 4'b0000;
            10'b0100000000: alu_control_signal = 4'b1000;
            10'b0000000001: alu_control_signal = 4'b0001;
            10'b0000000010: alu_control_signal = 4'b0010;
            10'b0000000011: alu_control_signal = 4'b0011;
            10'b0000000100: alu_control_signal = 4'b0100;
            10'b0000000101: alu_control_signal = 4'b0101;
            10'b0100000101: alu_control_signal = 4'b1101;
            10'b0000000110: alu_control_signal = 4'b0110;
            10'b0000000111: alu_control_signal = 4'b0111;
            default: alu_control_signal = 4'b0000;
        endcase
    end
endmodule
