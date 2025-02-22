`include "global.v"

module instruction_fetch(
    input [63:0] PC,
    output [31:0] instruction
);
    assign instruction = instr_mem[PC[11:2]]; // Fetch instruction based on PC value
endmodule