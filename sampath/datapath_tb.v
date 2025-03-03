`timescale 1ns / 1ps

module datapath_tb;
    // Testbench signals
    reg clock;
    reg [63:0] PC;
    
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
        $display("PC: %d, rs1: %d, rs2: %d", 
                uut.PC, uut.ID_stage.rs1, uut.ID_stage.rs2);
        
        #10;
        $display("PC: %d, rs1: %d, rs2: %d", 
                uut.PC, uut.ID_stage.rs1, uut.ID_stage.rs2);
        
        #10;
        $display("PC: %d, rs1: %d, rs2: %d", 
                uut.PC, uut.ID_stage.rs1, uut.ID_stage.rs2);

        #10;
        $display("PC: %d, rs1: %d, rs2: %d", 
                uut.PC, uut.ID_stage.rs1, uut.ID_stage.rs2);
        
        #10;
        $display("PC: %d, rs1: %d, rs2: %d", 
                uut.PC, uut.ID_stage.rs1, uut.ID_stage.rs2);

        #10;
        $display("PC: %d, rs1: %d, rs2: %d", 
                uut.PC, uut.ID_stage.rs1, uut.ID_stage.rs2);

        #10;
        $display("PC: %d, rs1: %d, rs2: %d", 
                uut.PC, uut.ID_stage.rs1, uut.ID_stage.rs2);
        
        #50;
        $finish;
    end
    
endmodule
