`include "CONTROL_UNIT.v"
`include "ADD_SUB.v"
`include "ADDER.v"
`include "AND.v"
`include "OR.v"
`include "XOR.v"

module ALU (a,b,instruction,Output);
    
    input [63:0] a;
    input [63:0] b;
    input [31:0] instruction;
    output reg [63:0] Output;

    wire [3:0] alu_control_signal;
    alu_control Alu_control (.instruction(instruction),.alu_control_signal(alu_control_signal));

    wire [63:0] add_sub_result;
    wire Cout;
    add_sub_unit Add_Sub_unit (.a(a),.b(b),.result(add_sub_result),.alu_control_signal(alu_control_signal),.Cout(Cout));

    wire [63:0] shift_result;
    wire [1:0] shift;
    assign shift = alu_control_signal[3:2];
    shift_unit Shift_unit (.a(a),.b(b),.direction(shift),.result(shift_result));

    wire [63:0] compare_result;
    compare_unit Compare_unit (.a(a),.b(b),.result(compare_result),.alu_control_signal(alu_control_signal));

    wire [63:0] and_result;
    and_unit And_unit (.a(a),.b(b),.out(and_result));

    wire [63:0] or_result;
    or_unit Or_unit (.a(a),.b(b),.out(or_result));

    wire [63:0] xor_result;
    xor_unit xor_unit (.a(a),.b(b),.result(xor_result));
    
    always @(*) begin
        if (alu_control_signal == 4'b0000 || alu_control_signal == 4'b1000) 
            Output = add_sub_result;
        else if (alu_control_signal == 4'b0100) 
            Output = xor_result;
        else if (alu_control_signal == 4'b0110) 
            Output = or_result;
        else if (alu_control_signal == 4'b0111) 
            Output = and_result;
        else 
            Output = 0; 
    end


endmodule


