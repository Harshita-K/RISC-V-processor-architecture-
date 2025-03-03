`include "global.v"

module instruction_fetch(
    inout reg [63:0] PC,  // Use inout so modification reflects globally
    output reg [31:0] instruction,  
    output reg invAddr
);

always @(*) begin
    if (PC[1:0] != 0 || PC[63:2] > 1023) begin
        invAddr = 1'b1;
        instruction = 32'hxxxxxxxx;  // Invalid instruction
    end else begin
        invAddr = 1'b0;
        instruction = instr_mem[PC[11:2]];  // Fetch instruction

        // MODIFY PC -> THIS REFLECTS IN ALL MODULES
        PC = PC + 4;  // Move to next instruction
    end
end

endmodule
