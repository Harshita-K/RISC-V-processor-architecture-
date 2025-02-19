module compare_unit (a, b, result, alu_control_signal);
    input [63:0] a;
    input [63:0] b;
    input [3:0] alu_control_signal;
    output reg [63:0] result;
    wire [63:0] sub_result;
    wire Cout;
    add_sub_unit Adder_sub_unit (.a(a),.b(b),.result(sub_result),.alu_control_signal(4'b1000),.Cout(Cout));
    always @(*) begin
    if ((alu_control_signal[0] == 1) && (Cout == 1))
        assign result = 64'b0;
    else if (sub_result[63] == 1) 
        assign result = {63'b0,1'b1};
    else
        assign result = 64'b0;
    end
endmodule
