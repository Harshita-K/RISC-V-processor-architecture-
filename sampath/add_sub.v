module add_sub_unit (a, b, result, alu_control_signal, Cout);
    input  [63:0] a;
    input  [63:0] b;
    input [3:0] alu_control_signal;
    output [63:0] result;
    output Cout;
    
    wire [63:0] xor_b;
    wire [63:0] xor_bit = {64{alu_control_signal[3]}};
    reg [63:0] b_selected;
    wire Cin;
    assign Cin = alu_control_signal[3];
    xor_unit Xor_unit (.a(xor_bit), .b(b), .result(xor_b));
    adder_unit Add_Sub_Unit (.a(a), .b(xor_b), .sum(result), .Cin(Cin), .Cout(Cout));
    
endmodule
