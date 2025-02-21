module datapath(
    input clk,
    input reset
);
    // PC and instruction memory
    reg [63:0] PC;
    reg [31:0] instr_mem [1023:0];

    // Registers and data memory
    reg [63:0] register [31:0];
    reg [63:0] data_memory [1023:0];

    // Wires to connect modules
    wire [31:0] instruction;
    wire [63:0] rd1, rd2, alu_result, next_PC, write_data;
    wire [4:0] write_addr;
    wire [3:0] alu_control_signal;
    wire RegWrite, MemRead, MemWrite, MemtoReg, Branch;

    // Instruction Fetch
    instruction_fetch IF (
        .PC(PC),
        .instr_mem(instr_mem),
        .instruction(instruction)
    );

    // Instruction Decode
    instruction_decode ID (
        .instruction(instruction),
        .register(register),
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

    // Execute
    execute EX (
        .alu_control_signal(alu_control_signal),
        .rd1(rd1),
        .rd2(rd2),
        .PC(PC),
        .immediate({{52{instruction[31]}}, instruction[31:20]}),
        .Branch(Branch),
        .alu_output(alu_result),
        .next_PC(next_PC)
    );

    // Memory Access
    wire [63:0] mem_data;
    memory_access MA (
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .address(alu_result),
        .write_data(rd2),
        .data_memory(data_memory),
        .wd(mem_data)
    );

    // Write Back
    write_back WB (
        .alu_result(alu_result),
        .mem_data(mem_data),
        .MemtoReg(MemtoReg),
        .write_data(write_data)
    );

    // Updating PC on clock edge
    always @(posedge clk or posedge reset) begin
        if (reset)
            PC <= 64'd0;
        else
            PC <= next_PC; // Update PC with the computed next PC
    end

    // Register Write-Back
    always @(posedge clk) begin
        if (RegWrite)
            register[write_addr] <= write_data;
    end

endmodule
