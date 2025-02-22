module MUX (
    input [63:0] in0, 
    input [63:0] in1, 
    input sel, 
    output reg [63:0] out
);
    always @(*) begin
        if (sel)
            out = in1;
        else
            out = in0;
    end
endmodule