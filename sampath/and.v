module bitwise_and (a, b, result);
    input a;
    input b;
    output wire result;
    
    assign result = a & b;
endmodule

module and_unit (a, b, out);
    input [63:0] a;
    input [63:0] b;
    output wire [63:0] out;
    
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : bitwise_and_loop
            bitwise_and and_inst (
                .a(a[i]),
                .b(b[i]),
                .result(out[i])
            );
        end
    endgenerate
endmodule
