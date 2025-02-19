`timescale 1ns / 1ps

module compare_unit_tb;

    // Testbench Signals
    reg [63:0] a, b;
    reg [9:0] decoder_output;
    wire result;

    // Instantiate the DUT (Device Under Test)
    compare_unit uut (
        .a(a),
        .b(b),
        .decoder_output(decoder_output),
        .result(result)
    );

    // Test Procedure
    initial begin
        // Test Case 1: Unsigned SLT (a < b)
        a = 64'hFFFFFFFFFFFFFFFF; 
        b = 64'd1;
        decoder_output = 10'b0000000000; // decoder_output[0] = 1 (unsigned SLT)
        #10;
        $display("Test 1: a = %d, b = %d, result = %b", a, b, result);

        // Test Case 2: Unsigned SLT (a > b)
        a = 64'd30; 
        b = 64'd15;
        decoder_output = 10'b0000000001; // decoder_output[0] = 1 (unsigned SLT)
        #10;
        $display("Test 2: a = %d, b = %d, result = %b", a, b, result);

        // Test Case 3: Equal values
        a = 64'd25;
        b = 64'd25;
        decoder_output = 10'b0000000001; // decoder_output[0] = 1 (unsigned SLT)
        #10;
        $display("Test 3: a = %d, b = %d, result = %b", a, b, result);

        // Test Case 4: Different decoder value (shouldn't trigger SLT)
        a = 64'd5;
        b = 64'd10;
        decoder_output = 10'b0000000010; // decoder_output[1] is set, SLT should NOT apply
        #10;
        $display("Test 4: a = %d, b = %d, result = %b", a, b, result);

        // End simulation
        $finish;
    end
endmodule
