`timescale 1ns/1ps

module barrelShifter64_tb;
    reg [63:0] a;
    reg [4:0] b;
    reg [1:0] shift;
    wire [63:0] result;
    
    shift_unit uut (
        .a(a),
        .b(b),
        .shift(shift),
        .result(result)
    );
    
    initial begin
        $dumpfile("file.vcd");
        $dumpvars(0, barrelShifter64_tb);

        
        a = 64'd2; b = 5'd1; shift = 2'b10; #10; // Logical left shift by 1
        $display("a=%b | b=%d | shift=%b | result=%b", $signed(a), b, shift, $signed(result));
        
        $finish;
    end
endmodule
