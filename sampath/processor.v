module Processor(clk);
    inptu clk;
    wire [63:0] pc, next_pc, instruction_address;
    wire [31:0] instruction;
    wire [6:0] opcode;
    wire [4:0] rs1, rs2, rd;
    wire [63:0] rd1, rd2, wd, alu_result, mem_read_data;
    wire [63:0] sign_extended_imm, alu_input2;
    wire [1:0] ALUOp;
    wire RegWrite, ALUSrc, MemRead, MemWrite, Branch;

    pc_register pc_reg (
        .clk(clk),
        .next_pc(next_pc),
        .pc(pc)
    );

    assign instruction_address = pc;
    
    instruction_memory instr_mem (
        .address(instruction_address),
        .instruction(instruction)
    );

    assign opcode = instruction[6:0];
    assign rd = instruction[11:7];
    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];

    ControlUnit control (
        .opcode(opcode),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .ALUOp(ALUOp)
    );

    RegisterFile reg_file (
        .clk(clk),
        .write_enable(RegWrite),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wd(wd),
        .rd1(rd1),
        .rd2(rd2)
    );

    assign sign_extended_imm = {{52{instruction[31]}}, instruction[31:20]};
    assign alu_input2 = ALUSrc ? sign_extended_imm : rd2;
    assign alu_result = rd1 + alu_input2;

    data_memory data_mem (
        .clk(clk),
        .address(alu_result),
        .write_data(rd2),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .read_data(mem_read_data)
    );

    assign wd = MemRead ? mem_read_data : alu_result;
    assign next_pc = pc + 4;
endmodule
