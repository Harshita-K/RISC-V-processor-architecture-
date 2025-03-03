`timescale 1ns / 1ps

module datapath_tb;
    // Testbench signals
    reg clock;
    reg [63:0] PC;
    wire [31:0] instruction;
    wire invAddr;
    wire [63:0] alu_output, next_PC;
    wire [63:0] wd;
    wire invMemAddr;
    
    // Instantiate the datapath module
    datapath uut (
        .clock(clock)
    );
    
    // Clock generation
    always #5 clock = ~clock; // Generate a clock with period 10ns
    
    // Test sequence
    initial begin
        $dumpfile("file.vcd");
        $dumpvars(0, datapath_tb);
        
        clock = 0;
        uut.PC = 64'd0;
        
        #5;
        $display("PC: %d, WD: %h", uut.PC, uut.IF_stage.instruction);
        PC = 64'd4; // Move to next instruction
        
        #10;
        $display("PC: %d, WD: %h", uut.PC, uut.IF_stage.instruction);
        PC = 64'd8; // Another instruction
        
        #10;
        $display("PC: %d, WD: %h", uut.PC, uut.IF_stage.instruction);
        PC = 64'd12; // Test sequence continues
        
        #50;
        $finish;
    end
    
endmodule
