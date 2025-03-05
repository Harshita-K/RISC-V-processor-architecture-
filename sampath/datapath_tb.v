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
    always #5 begin
        clock = ~clock; // Generate a clock with period 10ns
        $display("PC: %d, rd1: %d, rd2: %d", 
        uut.PC, uut.rd1, uut.rd2);
    end

    
    // Test sequence
    initial begin
        $dumpfile("file.vcd");
        $dumpvars(0, datapath_tb);
        
        clock = 0;
        uut.PC = 64'd0;
        
        // #5;
        // $display("PC: %d, rd1: %d, rd2: %d, alu_out: %d, RegWrite: %b, MemRead: %b, MemtoReg: %b, MemWrite: %b, Branch: %b, read_data: %d, write_data: %d", 
        // uut.PC, uut.rd1, uut.rd2, uut.alu_output, uut.RegWrite, uut.MemRead, uut.MemtoReg, uut.MemWrite, uut.Branch, uut.read_data, uut.wd);

        // #10;
        
        // $display("PC: %d, rd1: %d, rd2: %d, alu_out: %d, RegWrite: %b, MemRead: %b, MemtoReg: %b, MemWrite: %b, Branch: %b, read_data: %d, write_data: %d", 
        //  uut.PC, uut.rd1, uut.rd2, uut.alu_output, uut.RegWrite, uut.MemRead, uut.MemtoReg, uut.MemWrite, uut.Branch, uut.read_data, uut.wd);

        // #10;
        // $display("PC: %d, rd1: %d, rd2: %d, alu_out: %d, RegWrite: %b, MemRead: %b, MemtoReg: %b, MemWrite: %b, Branch: %b, read_data: %d, write_data: %d", 
        //         uut.PC, uut.rd1, uut.rd2, uut.alu_output, uut.RegWrite, uut.MemRead, uut.MemtoReg, uut.MemWrite, uut.Branch, uut.read_data, uut.wd);

        // #10;
        // $display("PC: %d, rd1: %d, rd2: %d, alu_out: %d, RegWrite: %b, MemRead: %b, MemtoReg: %b, MemWrite: %b, Branch: %b, read_data: %d, write_data: %d", 
        //         uut.PC, uut.rd1, uut.rd2, uut.alu_output, uut.RegWrite, uut.MemRead, uut.MemtoReg, uut.MemWrite, uut.Branch, uut.read_data, uut.wd);

        
        // #10;
        // $display("PC: %d, rd1: %d, rd2: %d, alu_out: %d, RegWrite: %b, MemRead: %b, MemtoReg: %b, MemWrite: %b, Branch: %b, read_data: %d, write_data: %d", 
        //  uut.PC, uut.rd1, uut.rd2, uut.alu_output, uut.RegWrite, uut.MemRead, uut.MemtoReg, uut.MemWrite, uut.Branch, uut.read_data, uut.wd);

        // #10;
        // $display("PC: %d, rd1: %d, rd2: %d, alu_out: %d, RegWrite: %b, MemRead: %b, MemtoReg: %b, MemWrite: %b, Branch: %b, read_data: %d, write_data: %d",
        //         uut.PC, uut.rd1, uut.rd2, uut.alu_output, uut.RegWrite, uut.MemRead, uut.MemtoReg, uut.MemWrite, uut.Branch, uut.read_data, uut.wd);

        // #10;
        // $display("PC: %d, rd1: %d, rd2: %d, alu_out: %d, RegWrite: %b, MemRead: %b, MemtoReg: %b, MemWrite: %b, Branch: %b, read_data: %d, write_data: %d", 
        //         uut.PC, uut.rd1, uut.rd2, uut.alu_output, uut.RegWrite, uut.MemRead, uut.MemtoReg, uut.MemWrite, uut.Branch, uut.read_data, uut.wd);

        
        #50;
        $finish;
    end
    
endmodule
