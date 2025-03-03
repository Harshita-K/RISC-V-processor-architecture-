module shift_unit (a, b, direction, result);
    input [63:0] a;
    input [63:0] b;
    input [1:0] direction;
    output reg [63:0] result;
    reg [63:0] temp;
    wire [4:0] shift;
    assign shift = b[4:0];
    always @(*) begin
        temp = a;
        if (shift[0] == 1)
            case (direction)
                2'b00: temp = {temp[62:0], 1'b0};
                2'b11: temp = {temp[63], temp[63:1]};
                default: temp = {1'b0, temp[63:1]};
            endcase
        if (shift[1] == 1)
            case (direction)
                2'b00: temp = {temp[61:0], 2'b0};
                2'b11: temp = {{2{temp[63]}}, temp[63:2]};
                default: temp = {2'b0, temp[63:2]};
            endcase
        if (shift[2] == 1)
            case (direction)
                2'b00: temp = {temp[59:0], 4'b0};
                2'b11: temp = {{4{temp[63]}}, temp[63:4]};
                default: temp = {4'b0, temp[63:4]};
            endcase
        if (shift[3] == 1)
            case (direction)
                2'b00: temp = {temp[55:0], 8'b0};
                2'b11: temp = {{8{temp[63]}}, temp[63:8]};
                default: temp = {8'b0, temp[63:8]};
            endcase
        if (shift[4] == 1)
            case (direction)
                2'b00: temp = {temp[47:0], 16'b0};
                2'b11: temp = {{16{temp[63]}}, temp[63:16]};
                default: temp = {16'b0, temp[63:16]};
            endcase
        result = temp;
    end
    
endmodule
