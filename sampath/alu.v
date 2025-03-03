`include "add_sub.v"
`include "adder.v"
`include "and.v"
`include "or.v"
`include "xor.v"
`include "shift.v"

module ALU (a,b,alu_control_signal, alu_result);
    
    input [63:0] a;
    input [63:0] b;
    input [3:0] alu_control_signal;
    output reg [63:0]  alu_result;

    wire [63:0] add_sub_result;
    wire Cout;
    add_sub_unit Add_Sub_unit (.a(a),.b(b),.result(add_sub_result),.alu_control_signal(alu_control_signal),.Cout(Cout));

    wire [63:0] shift_result;
    wire [1:0] shift;
    assign shift = alu_control_signal[3:2];
    shift_unit Shift_unit (.a(a),.b(b),.direction(shift),.result(shift_result));

    wire [63:0] and_result;
    and_unit And_unit (.a(a),.b(b),.out(and_result));

    wire [63:0] or_result;
    or_unit Or_unit (.a(a),.b(b),.out(or_result));

    wire [63:0] xor_result;
    xor_unit xor_unit (.a(a),.b(b),.result(xor_result));
    
    always @(*) begin
        if (alu_control_signal == 4'b0000 || alu_control_signal == 4'b1000) 
             alu_result = add_sub_result;
        else if (alu_control_signal == 4'b0100) 
             alu_result = xor_result;
        else if (alu_control_signal == 4'b0110) 
             alu_result = or_result;
        else if (alu_control_signal == 4'b0111) 
             alu_result = and_result;
        else 
             alu_result = 0; 
    end


endmodule


