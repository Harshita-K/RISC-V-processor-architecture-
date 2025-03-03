
reg [31:0] instr_mem [0:1023];  // 1024 words of 32-bit instructions

// Program Counter - 64 bits
reg [63:0] PC;

// Register file - 32 registers of 64 bits each
reg [63:0] register_file [0:31];

// Initial values (optional)
initial begin
    // Initialize PC to start of memory
    PC = 64'h0000000000000000;
end