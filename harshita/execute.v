`include "alu.v"
`include "adder.v"
`include "MUX.v"
`include "global.v"

module execute(
    input [3:0] alu_control_signal,
    input [63:0] rd1,
    input [63:0] rd2,
    input [63:0] PC,
    input [63:0] immediate,
    input Branch, // Branch control signal for MUX selection
    output [63:0] alu_output,
    output [63:0] next_PC
);
    wire [63:0] updated_PC;
    wire [63:0] branch_target;

    // ALU computation for normal operations
    ALU alu_main (
        .a(rd1),
        .b(rd2),
        .alu_control_signal(alu_control_signal),
        .alu_result(alu_output)
    );

    // PC update logic
    adder_unit pc_adder (
        .a(PC),
        .b(64'd4),
        .Cin(1'b0),
        .sum(updated_PC),
        .Cout() // We don't need carry out for PC update
    );
    
    assign branch_target = PC + (immediate << 1);
    
    MUX PC_mux (
        .sel(Branch),
        .in0(updated_PC),
        .in1(branch_target),
        .out(next_PC)
    );

endmodule