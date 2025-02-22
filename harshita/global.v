// ========================== Global Memory and Registers ==========================

// Instruction Memory (stores 32-bit instructions, up to 1024 instructions)
reg [31:0] instr_mem [0:1023];  

// Data Memory (stores 64-bit values, up to 1024 memory locations)
reg [63:0] data_mem [0:1023];   

// Register File (32 registers, each 64-bit wide)
reg [63:0] register_file [0:31];

// ========================== End of Global Declarations ==========================