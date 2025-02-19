module instruction_memory(address,instruction);
    input [63:0] address;       
    output reg [31:0] instruction;
    reg [31:0] instruction_memory [0:1023];

    initial begin
        instruction_memory[0] = 32'h00208133;  
        instruction_memory[1] = 32'h401101B3;  
        instruction_memory[2] = 32'h0020F233;  
        instruction_memory[3] = 32'h0020E2B3;  
        instruction_memory[4] = 32'h0080A383;  
        instruction_memory[5] = 32'h0020A623;  
        instruction_memory[6] = 32'h00208863;  

        for (int i = 7; i < 1024; i = i + 1) 
            instruction_memory[i] = 32'h00000013;  
    end

    always @(*) 
        instruction = instruction_memory[address];

endmodule
