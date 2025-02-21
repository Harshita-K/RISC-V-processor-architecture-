module alu_control (instruction,alu_op,alu_control_signal);

    input [31:0] instruction;
    input [1:0] alu_op;
    output reg [3:0] alu_control_signal;
    reg [9:0] funct7_func3;

    always @(*) begin
        if (alu_op == 2'b00) s
            alu_control_signal = 4'b0010;
        else if (alu_op == 2'b01) 
            alu_control_signal = 4'b0110;
        else if (alu_op == 2'b10) begin
            if ({instruction[31:25], instruction[14:12]} == 10'b0000000000) 
                alu_control_signal = 4'b0010;
            else if ({instruction[31:25], instruction[14:12]} == 10'b0100000000) 
                alu_control_signal = 4'b0110;
            else if ({instruction[31:25], instruction[14:12]} == 10'b0000000001) 
                alu_control_signal = 4'b0001;
            else if ({instruction[31:25], instruction[14:12]} == 10'b0000000010) 
                alu_control_signal = 4'b0111;
            else if ({instruction[31:25], instruction[14:12]} == 10'b0000000011) 
                alu_control_signal = 4'b1100;
            else if ({instruction[31:25], instruction[14:12]} == 10'b0000000100) 
                alu_control_signal = 4'b0000;
            else if ({instruction[31:25], instruction[14:12]} == 10'b0000000101) 
                alu_control_signal = 4'b0100;
            else if ({instruction[31:25], instruction[14:12]} == 10'b0100000101) 
                alu_control_signal = 4'b1101;
            else if ({instruction[31:25], instruction[14:12]} == 10'b0000000110) 
                alu_control_signal = 4'b0001;
            else if ({instruction[31:25], instruction[14:12]} == 10'b0000000111) 
                alu_control_signal = 4'b0011;
            else 
                alu_control_signal = 4'b1111;
        end else 
            alu_control_signal = 4'b1111;
    end
endmodule

