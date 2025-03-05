module execute(
    input [3:0] alu_control_signal,
    input [63:0] rd1,
    input [63:0] rd2,
    input [63:0] PC,
    input [63:0] immediate,
    input Branch, 
    input [1:0] ALUOp,
    output [63:0] alu_output,
    output [63:0] next_PC, 
    output reg zero
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
    always @(*) begin
        if(ALUOp == 2'b01) begin
            if(alu_output == 0)
                zero = 1;
            else
                zero = 0;
        end else begin
            zero = 0; // or any default behavior
        end
    end

    // ALU for PC + 4
    // ALU alu_pc_update (
    //     .a(PC),
    //     .b(64'd4),
    //     .alu_control_signal(4'b0010), // Addition
    //     .alu_result(updated_PC)
    // );

    // ALU for shifting immediate left by 1 bit
    wire [63:0] shifted_immediate;
    ALU alu_shift (
        .a(immediate),
        .b(64'd1),
        .alu_control_signal(4'b0011), // Logical Shift Left
        .alu_result(shifted_immediate)
    );
    // assign branch_signal = Branch & (alu_output == 0);
    // // ALU for branch target calculation (PC + shifted immediate)
    ALU alu_branch (
        .a(PC),
        .b(shifted_immediate),
        .alu_control_signal(4'b0010), // Addition
        .alu_result(next_PC)
    );

    // MUX to choose between branch_target and updated_PC
    // Mux next_pc_mux (
    //     .input1(updated_PC),
    //     .input2(branch_target),
    //     .select(branch_signal),
    //     .out(next_PC)
    // );

endmodule

module EX_MEM_Reg (
    input wire clk,
    input wire rst,
    input wire [63:0] pc_in,
    input wire zero_in,
    input wire [63:0] alu_result_in,
    input wire [63:0] read_data2_in,
    input wire [4:0] write_reg_in,
    input wire branch_in,
    input wire memwrite_in,
    input wire memread_in,
    input wire memtoreg_in,
    input wire regwrite_in,
    
    output reg [63:0] pc_out,
    output reg zero_out,
    output reg [63:0] alu_result_out,
    output reg [63:0] read_data2_out,
    output reg [4:0] write_reg_out,
    output reg branch_out,
    output reg memwrite_out,
    output reg memread_out,
    output reg memtoreg_out,
    output reg regwrite_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        pc_out         <= 64'b0;
        zero_out       <= 1'b0;
        alu_result_out <= 32'b0;
        read_data2_out <= 32'b0;
        write_reg_out  <= 5'b0;
        branch_out     <= 1'b0;
        memwrite_out   <= 1'b0;
        memread_out    <= 1'b0;
        memtoreg_out   <= 1'b0;
        regwrite_out   <= 1'b0;
    end else begin
        pc_out         <= pc_in;
        zero_out       <= zero_in;
        alu_result_out <= alu_result_in;
        read_data2_out <= read_data2_in;
        write_reg_out  <= write_reg_in;
        branch_out     <= branch_in;
        memwrite_out   <= memwrite_in;
        memread_out    <= memread_in;
        memtoreg_out   <= memtoreg_in;
        regwrite_out   <= regwrite_in;
    end
end

endmodule