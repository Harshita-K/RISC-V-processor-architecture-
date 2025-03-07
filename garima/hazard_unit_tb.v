`timescale 1ns / 1ps

module HazardUnit_tb;
    // Inputs
    reg ID_EX_MemRead;
    reg [4:0] ID_EX_RegisterRd;
    reg [4:0] IF_ID_RegisterRs1;
    reg [4:0] IF_ID_RegisterRs2;
    
    // Outputs
    wire PCWrite;
    wire IF_ID_Write;
    wire stall;
    
    // Instantiate the HazardUnit module
    HazardUnit uut (
        .PCWrite(PCWrite),
        .IF_ID_Write(IF_ID_Write),
        .ID_EX_MemRead(ID_EX_MemRead),
        .ID_EX_RegisterRd(ID_EX_RegisterRd),
        .IF_ID_RegisterRs1(IF_ID_RegisterRs1),
        .IF_ID_RegisterRs2(IF_ID_RegisterRs2),
        .stall(stall)
    );
    
    // Test procedure
    initial begin
        $dumpfile("HazardUnit_tb.vcd");
        $dumpvars(0, HazardUnit_tb);
        
        // Case 1: No hazard (Default state)
        ID_EX_MemRead = 0;
        ID_EX_RegisterRd = 5'b00000;
        IF_ID_RegisterRs1 = 5'b00001;
        IF_ID_RegisterRs2 = 5'b00010;
        #10;
        
        // Case 2: Load-use hazard detected (stall should be 1)
        ID_EX_MemRead = 1;
        ID_EX_RegisterRd = 5'b00001;
        IF_ID_RegisterRs1 = 5'b00001;
        IF_ID_RegisterRs2 = 5'b00010;
        #10;
        
        // Case 3: Load-use hazard with different Rs2
        ID_EX_MemRead = 1;
        ID_EX_RegisterRd = 5'b00010;
        IF_ID_RegisterRs1 = 5'b00001;
        IF_ID_RegisterRs2 = 5'b00010;
        #10;
        
        // Case 4: No hazard (Different register values)
        ID_EX_MemRead = 1;
        ID_EX_RegisterRd = 5'b00011;
        IF_ID_RegisterRs1 = 5'b00001;
        IF_ID_RegisterRs2 = 5'b00010;
        #10;
        
        // End simulation
        $finish;
    end
    
    // Monitor output changes
    initial begin
        $monitor("Time=%0t | MemRead=%b, Rd=%b, Rs1=%b, Rs2=%b | Stall=%b, PCWrite=%b, IF_ID_Write=%b", 
                 $time, ID_EX_MemRead, ID_EX_RegisterRd, IF_ID_RegisterRs1, IF_ID_RegisterRs2, 
                 stall, PCWrite, IF_ID_Write);
    end
    
endmodule