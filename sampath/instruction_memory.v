module instruction_memory(
    input [63:0] address,       
    output reg [31:0] instruction
);
    // Define instruction memory (1024 words, each 32 bits)
    reg [31:0] instruction_memory [0:1023];

    // Read instruction from memory
    always @(*) begin
        instruction = instruction_memory[address[11:2]]; // Word addressing (divide by 4)
    end

    // Initialize instruction memory (for simulation)
    initial begin
        instruction_memory[0] = 32'h00000093;  // addi x1, x0, 0
        instruction_memory[1] = 32'h00100113;  // addi x2, x0, 1
        instruction_memory[2] = 32'h002081b3;  // add x3, x1, x2
        instruction_memory[3] = 32'h00310233;  // add x4, x2, x3
        instruction_memory[4] = 32'h002182b3;  // add x5, x3, x2
        instruction_memory[5] = 32'hFE008CE3;  // beq x1, x2, -4
        instruction_memory[6] = 32'hxxxxxxxx;  // ECALL (halt)
        // Add more instructions as needed
    end
endmodule
