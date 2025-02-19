module bitwise_xor (a, b, result);
    input a;
    input b;
    output wire result;
    
    assign result = a ^ b;
endmodule

module xor_unit (a, b, result);
    input [63:0] a;
    input [63:0] b;
    output wire [63:0] result;
    
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin 

            bitwise_xor xor_inst (
                .a(a[i]),
                .b(b[i]),
                .result(result[i])
            );
        end
    endgenerate
endmodule
