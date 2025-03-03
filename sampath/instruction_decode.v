module instruction_decode(
    input [31:0] instruction, 
    output [63:0] rd1,
    output [63:0] rd2,
    output [4:0] write_addr,
    output [3:0] alu_control_signal,
    output RegWrite,
    output MemRead,
    output MemtoReg,
    output MemWrite,
    output Branch,
    output invOp,
    output invFunc,
    output invRegAddr
);
    `include "global.v"
    wire [6:0] opcode = instruction[6:0];
    wire [4:0] rs1 = instruction[19:15];
    wire [4:0] rs2 = instruction[24:20];
    wire [1:0] ALUOp;
    wire ALUSrc;
    wire invOp;
    wire invRegAddr;
    wire [63:0] immediate;
    
    assign write_addr = instruction[11:7];
    
    ControlUnit CU (
        .opcode(opcode),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .ALUOp(ALUOp),
        .invOp(invOp)
    );
    
    alu_control ALU_CTRL (
        .instruction(instruction),
        .alu_op(ALUOp),
        .invFunc(invFunc),
        .alu_control_signal(alu_control_signal)
    );

    assign immediate = {{52{instruction[31]}}, instruction[31:20]};
    assign invRegAddr = (rs1 > 5'd31) | (rs2 > 5'd31);
    assign rd1 = register[rs1];

    
    Mux alu_mux (
        .input1(register[rs2]),
        .input2(immediate),
        .select(ALUSrc),
        .out(rd2)
    );

endmodule

module Mux(
    input [63:0] input1,
    input [63:0] input2,
    input select,
    output [63:0] out
);
    assign out = select ? input2 : input1;
endmodule
