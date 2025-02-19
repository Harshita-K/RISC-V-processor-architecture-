`timescale 1ns / 1ps

module RegisterFile_tb;
    reg clk;
    reg write_enable;
    reg [4:0] rs1, rs2, rd;
    reg [63:0] wd;
    wire [63:0] rd1, rd2;
    
    // Instantiate the RegisterFile module
    RegisterFile uut (
        .clk(clk),
        .write_enable(write_enable),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wd(wd),
        .rd1(rd1),
        .rd2(rd2)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    initial begin
        // Initialize inputs
        $dumpfile("file.vcd");
        $dumpvars(0, RegisterFile_tb);
        clk = 0;
        write_enable = 0;
        rs1 = 0;
        rs2 = 0;
        rd = 0;
        wd = 0;
        
        // Apply reset time
        #10;
        
        // Test 1: Write value to register 1
        write_enable = 1;
        rd = 5'd1;
        wd = 64'hA5A5A5A5A5A5A5A5;
        #10;
        
        // Test 2: Read from register 1
        write_enable = 0;
        rs1 = 5'd1;
        rs2 = 5'd0;
        #10;
        $display("rd1 = %h, expected = A5A5A5A5A5A5A5A5", rd1);
        
        // Test 3: Ensure register 0 is always zero
        rs1 = 5'd0;
        #10;
        $display("rd1 = %h, expected = 0000000000000000", rd1);
        
        // Test 4: Write another value to register 2
        write_enable = 1;
        rd = 5'd2;
        wd = 64'h5A5A5A5A5A5A5A5A;
        #10;
        
        // Test 5: Read from register 2
        write_enable = 0;
        rs1 = 5'd2;
        rs2 = 5'd1;
        #10;
        $display("rd1 = %h, expected = 5A5A5A5A5A5A5A5A", rd1);
        $display("rd2 = %h, expected = A5A5A5A5A5A5A5A5", rd2);
        
        // Finish simulation
        #10;
        $finish;
    end
endmodule
