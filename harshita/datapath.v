`include "execute.v"
`include "instruction_decode.v"
`include "instruction_fetch.v"
`include "adder.v"
`include "MUX.v"
`include "write_back.v"
`include "memory_access.v"
`include "global.v"

module Datapath (
    input clk,
    input reset,
    output [63:0] PC,
    output [63:0] ALU_result,
    output Zero
);
    
    wire [63:0] rd1, rd2, immediate, wd, mem_data, write_data;
    wire [4:0] write_addr;
    wire [31:0] instruction;
    wire [3:0] alu_control_signal;
    wire RegWrite, MemRead, MemtoReg, MemWrite, Branch;
    wire [1:0] ALUOp;
    wire ALUSrc;

    // Program Counter
    reg [63:0] PC_reg;
    always @(posedge clk or posedge reset) begin
        if (reset)
            PC_reg <= 0;
        else
            PC_reg <= PC_reg + 4;
    end
    assign PC = PC_reg;

    //Instruction fetch
    instruction_fetch IF (
        .PC(PC),
        .instruction(instruction)
    );

    // Instruction Decode
    instruction_decode ID (
        .instruction(instruction),
        .rd1(rd1),
        .rd2(rd2),
        .write_addr(write_addr),
        .alu_control_signal(alu_control_signal),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .MemWrite(MemWrite),
        .Branch(Branch)
    );

    // Execution Stage
    execute EX (
        .alu_control_signal(alu_control_signal),
        .rd1(rd1),
        .rd2(rd2),
        .PC(PC),
        .immediate(immediate),
        .Branch(Branch),
        .alu_output(ALU_result),
        .next_PC()
    );

    // Memory Access Stage
    memory_access MEM (
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .address(ALU_result),  // ALU result as the address for memory operations
        .write_data(rd2),  // Data to be written to memory
        .wd(mem_data),  // Data read from memory
        .data_mem(data_mem)  // Pass global data memory
    );

    // Write-back Stage (Using write_back module)
    write_back WB (
        .alu_result(ALU_result),  // ALU result to be written back
        .mem_data(mem_data),  // Data read from memory to be written back
        .MemtoReg(MemtoReg),  // Control signal to select between ALU result and memory data
        .write_data(write_data)  // Final write-back data
    );

    // Register Write Stage: Writing data back to the register file
    always @(posedge clk or posedge reset) begin
        if (reset)
            register_file[write_addr] <= 0;
        else if (RegWrite)
            register_file[write_addr] <= write_data;
    end

    assign Zero = (ALU_result == 0);

endmodule