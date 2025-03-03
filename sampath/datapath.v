`include "instruction_fetch.v"
`include "instruction_decode.v"
`include "control_unit.v"
`include "alu_control.v"
`include "alu.v"
`include "execute.v"
`include "memory_access.v"

module datapath(
    input wire clock,
    input wire reset
);

    reg [63:0] PC;
    reg [63:0] register [0:31];
    reg [63:0] data_memory [0:1023];

    initial begin
        // Initialize registers to specific values
        register[0]  = 64'h0000000000000000; // x0 (zero register, always 0)
        register[5]  = 64'h0000000000000005; // x5  = 5
        register[10] = 64'h000000000000000A; // x10 = 10
        register[11] = 64'h000000000000000B; // x11 = 11
        register[12] = 64'h000000000000000C; // x12 = 12
        register[13] = 64'h0000000000000010; // x13 = 16

        // Initialize data memory to specific values
        data_memory[0] = 64'h0000000000000001;
        data_memory[1] = 64'h0000000000000002;
        data_memory[2] = 64'h0000000000000003;
        data_memory[3] = 64'h0000000000000004;
        data_memory[4] = 64'h0000000000000005;
        data_memory[5] = 64'h0000000000000006;
        data_memory[6] = 64'h0000000000000007;
        data_memory[7] = 64'h0000000000000008;
        data_memory[8] = 64'h0000000000000009;
        data_memory[9] = 64'h000000000000000A;
        data_memory[20] = 64'h000000000000000A;
    end

    
    wire [31:0] instruction;
    wire invAddr;
    wire [4:0] rs1, rs2;
    wire [63:0] rd1, rd2;
    wire [4:0] write_addr;
    wire [3:0] alu_control_signal;
    wire RegWrite, MemRead, MemtoReg, MemWrite, Branch;
    wire invOp, invFunc, invRegAddr;
    wire [63:0] alu_output, next_PC;
    wire [63:0] wd;
    wire invMemAddr;
    wire [63:0] immediate;
    reg [63:0] read_data;
    

    instruction_fetch IF_stage (
        .PC(PC),
        .instruction(instruction),
        .invAddr(invAddr)
    );

    instruction_decode ID_stage (
        .instruction(instruction),
        .rs1(rs1),
        .rs2(rs2),
        .write_addr(write_addr),
        .alu_control_signal(alu_control_signal),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .invOp(invOp),
        .invFunc(invFunc),
        .invRegAddr(invRegAddr)
    );

    assign immediate = MemWrite ? {{52{instruction[31]}}, instruction[31:25], instruction[11:7]} 
    : {{52{instruction[31]}}, instruction[31:20]};

    assign invRegAddr = (rs1 > 5'd31) | (rs2 > 5'd31);
    assign rd1 = register[rs1];

    
    Mux alu_mux (
        .input1(register[rs2]),
        .input2(immediate),
        .select(ALUSrc),
        .out(rd2)
    );

    // Execute Stage
    execute EX_stage (
        .alu_control_signal(alu_control_signal),
        .rd1(rd1),
        .rd2(rd2),
        .PC(PC),
        .immediate(immediate),
        .Branch(Branch),
        .alu_output(alu_output),
        .next_PC(next_PC)
    );
    
    // Memory Access Stage
    memory_access MEM_stage (
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .address(alu_output),
        .invMemAddr(invMemAddr)
    );

    always @(*) begin
        if (~invMemAddr)  begin
            if (MemRead) 
                read_data <= data_memory[alu_output]; // Read from memory
            
            if (MemWrite) 
                data_memory[alu_output] <= rd2; // Write to memory
        end
    end

    Mux mem_mux (
        .input1(alu_output),
        .input2(read_data),
        .select(MemtoReg),
        .out(wd)
    );


    always @(posedge clock or posedge reset) begin
        if (reset)
            PC <= 64'd0; // Reset PC to 0
        else
            PC <= next_PC; // Update PC based on execution stage output
    end

    always @(posedge clock) begin
        if(RegWrite & !invRegAddr)
            register[write_addr ] <= wd;
        else if (MemWrite & !invMemAddr)
            data_memory[alu_output / 8] <= wd;    
    end
    
    
endmodule



