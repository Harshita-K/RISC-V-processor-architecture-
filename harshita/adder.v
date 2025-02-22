module bitwise_adder (a, b, cin, sum, cout);
    input a;
    input b;
    input cin;
    output sum;
    output cout;
    wire w1, w2, w3;

    xor x1(w1, a, b);
    xor x2(sum, w1, cin);
    and a1(w2, a, b);
    and a2(w3, w1, cin);
    or o1(cout, w2, w3);
endmodule

module adder_unit (a, b, sum, Cin, Cout);
    input  [63:0] a;
    input  [63:0] b;
    input Cin;
    output wire [63:0] sum;
    output Cout;
    wire [64:0] carry;
    assign carry[0] = Cin;

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) 
        begin
            bitwise_adder Adder (a[i], b[i], carry[i], sum[i], carry[i+1]);
        end
    endgenerate
    assign Cout = carry[64];

    
endmodule
