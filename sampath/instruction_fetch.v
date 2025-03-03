
module instruction_fetch(
    output reg [31:0] instruction,   // Output register for the fetched instruction
    output reg invAddr      // Invalid address flag
);

    `include "global.v"

    always @(*) begin
        if (PC[1:0] != 0 || PC[63:2] > 1023) begin
            // Address is invalid if upper bits are non-zero or not word-aligned
            invAddr <= 1'b1;
            instruction <= 32'hxxxxxxxx; // Output zero for invalid addresses
        end else begin
            // Valid address, fetch the instruction
            invAddr <= 1'b0;
            instruction <= instr_mem[PC[11:2]]; // Use 10 bits for indexing 1024 entries
        end
    end


endmodule