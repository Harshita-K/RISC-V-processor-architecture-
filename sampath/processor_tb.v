`timescale 1ns / 1ps

module Processor_tb;
    reg clk;
    reg reset;

    // Instantiate the Processor module
    Processor uut (
        .clk(clk),
        .reset(reset)
    );

    // Clock Generation: Toggle every 5ns (10ns period, 100MHz)
    always #5 clk = ~clk;

    initial begin
        // Initialize clock and reset
        $dumpfile("file.vcd");
        $dumpvars(0, Processor_tb);
        clk = 0;
        reset = 1;

        // Apply Reset
        #20;
        reset = 0;

        // Run simulation for a specific period
        #500;

        // Stop simulation
        $finish;
    end

    // Monitor key signals
    initial begin
        $monitor("Time = %t, PC = %h", $time, uut.pc_reg.pc);
    end
endmodule
