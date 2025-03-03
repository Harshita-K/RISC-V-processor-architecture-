`include "instruction_fetch.v"
`include "instruction_decode.v"
`include "control_unit.v"
`include "alu_control.v"


module datapath( 
    output [63:0] rd1, rd2,  // Register read outputs
    output [4:0] write_addr,  // Destination register address
    output [3:0] alu_control_signal,  // ALU control signal
    output RegWrite, MemRead, MemtoReg, MemWrite, Branch  // Control signals
);
    `include "global.v"
wire [31:0] instruction; // Wire to hold fetched instruction
wire invRegAddr; 
wire invOp; // Invalid address flag (not used here, but can be useful for debugging)

// Instruction Fetch Stage
instruction_fetch IF_stage (
    .instruction(instruction),
    .invAddr(invAddr)
);

// Instruction Decode Stage
instruction_decode ID_stage (
    .instruction(instruction),
    .rd1(rd1),
    .rd2(rd2),
    .write_addr(write_addr),
    .alu_control_signal(alu_control_signal),
    .invOp(invOp),
    .invRegAddr(invRegAddr),
    .invFunc(invFunc),
    .RegWrite(RegWrite),
    .MemRead(MemRead),
    .MemtoReg(MemtoReg),
    .MemWrite(MemWrite),
    .Branch(Branch)
);

endmodule
