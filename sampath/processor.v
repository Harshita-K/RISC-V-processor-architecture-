module riscv_processor(
    input clk
);

    // Program Counter (PC)
    reg [63:0] PC;
    
    // Register File (32 registers, 64-bit each)
    reg [63:0] registers [31:0];
    
    // Data Memory (1024 locations, 64-bit each)
    reg [63:0] data_mem [1023:0];
    
    // Instruction Memory (1024 locations, 32-bit each)
    reg [31:0] instr_mem [1023:0];
    
    initial begin
        PC = 64'b0; // Initialize PC to zero
    end
    
endmodule
