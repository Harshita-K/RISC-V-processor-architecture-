`include "instruction_fetch.v"
`include "instruction_decode.v"
`include "alu_control.v"
`include "alu.v"
`include "execute.v"
`include "memory_access.v"
`include "hazard_unit.v"
`include "fwdunit.v"

module datapath(
    input wire clock,
    input wire reset
);

    reg [63:0] PC;
    reg [63:0] register [0:31];
    reg [63:0] data_memory [0:1023];

    initial begin
       register[0]  = 64'h0000000000000000; // x0 (zero register, always 0)
        register[5]  = 64'h0000000000000005; // x5  = 5
        register[10] = 64'h000000000000000A; // x10 = 10
        register[11] = 64'h000000000000000B; // x11 = 11
        register[12] = 64'h000000000000000C; // x12 = 12
        register[13] = 64'h000000000000000D; // x13 = 13
        register[14] = 64'h00000000000000F0; // x14 = 14
        register[15] = 64'h00000000000000F8; // x15 = 15
        data_memory[31] = 64'h000000000000001F;
    end

    wire [31:0] instruction;
    wire invAddr;
    
    instruction_fetch fetch_unit (
        .PC(PC),
        .instruction(instruction),
        .invAddr(invAddr)
    );

    wire [63:0] pc_if_id;
    wire [31:0] instruction_if_id;

    wire PCWrite, IF_ID_Write, stall;
    HazardUnit hazard_unit (
        .PCWrite(PCWrite),
        .IF_ID_Write(IF_ID_Write),
        .ID_EX_MemRead(memread_id_ex),
        .ID_EX_RegisterRd(write_reg_id_ex),
        .IF_ID_RegisterRs1(instruction_if_id[19:15]),
        .IF_ID_RegisterRs2(instruction_if_id[24:20]),
        .stall(stall)
    );

    IF_ID_Reg if_id_register (
        .clk(clock),
        .rst(reset),
        .pc_in(PC),
        .instruction_in(instruction),
        .pc_out(pc_if_id),
        .instruction_out(instruction_if_id)
    );

// Instruction Decode Stage
    wire [4:0] rs1, rs2, write_reg;
    wire [9:0] alu_control;
    wire alusrc, regwrite, memread, memtoreg, memwrite, branch, invOp, invFunc, invRegAddr;
    wire [1:0] ALUOp;

    instruction_decode decode_unit (
        .instruction(instruction_if_id),
        .rs1(rs1),
        .rs2(rs2),
        .write_addr(write_reg),
        .alu_control(alu_control),
        .ALUSrc(alusrc),
        .ALUOp(ALUOp),
        .RegWrite(regwrite),
        .MemRead(memread),
        .MemtoReg(memtoreg),
        .MemWrite(memwrite),
        .Branch(branch),
        .invOp(invOp),
        .invFunc(invFunc),
        .invRegAddr(invRegAddr)
    );


    // ID/EX Pipeline Register
    wire [63:0] pc_id_ex, rd1_id_ex, rd2_id_ex, imm_val_id_ex;
    wire [3:0] alu_control_id_ex;
    wire [4:0] write_reg_id_ex, register_rs1_id_ex, register_rs2_id_ex;
    wire alusrc_id_ex, branch_id_ex, memwrite_id_ex, memread_id_ex, memtoreg_id_ex, regwrite_id_ex;

    wire control_after_hazard;
    assign control_after_hazard = (stall) ? 0 : 1;

    assign alusrc   = control_after_hazard ? alusrc : 0;
    assign ALUOp    = control_after_hazard ? ALUOp : 0;
    assign branch   = control_after_hazard ? branch : 0;
    assign memwrite = control_after_hazard ? memwrite : 0;
    assign memread  = control_after_hazard ? memread : 0;
    assign memtoreg = control_after_hazard ? memtoreg : 0;
    assign regwrite = control_after_hazard ? regwrite : 0;

    wire [1:0] alu_op_id_ex;
    ID_EX_Reg id_ex_register (
        .clk(clock),
        .rst(reset),
        .pc_in(pc_if_id),
        .read_data1_in(register[rs1]),
        .read_data2_in(register[rs2]),
        .imm_val_in(instruction_if_id),
        .write_reg_in(write_reg),
        .alu_control_in(alu_control),
        .alusrc_in(alusrc),
        .branch_in(branch),
        .memwrite_in(memwrite),
        .memread_in(memread),
        .memtoreg_in(memtoreg),
        .regwrite_in(regwrite),
        .register_rs1_in(instruction_if_id[19:15]),
        .register_rs2_in(instruction_if_id[24:20]),
        .alu_op_in(ALUOp),
        .pc_out(pc_id_ex),
        .read_data1_out(rd1_id_ex),
        .read_data2_out(rd2_id_ex),
        .imm_val_out(imm_val_id_ex),
        .write_reg_out(write_reg_id_ex),
        .alu_control_out(alu_control_id_ex),
        .alusrc_out(alusrc_id_ex),
        .branch_out(branch_id_ex),
        .memwrite_out(memwrite_id_ex),
        .memread_out(memread_id_ex),
        .memtoreg_out(memtoreg_id_ex),
        .regwrite_out(regwrite_id_ex),
        .register_rs1_out(register_rs1_id_ex),
        .register_rs2_out(register_rs2_id_ex),
        .alu_op_out(alu_op_id_ex)
    );

    alu_control ALU_CTRL (
        .alu_op(alu_op_id_ex),
        .invFunc(invFunc),
        .alu_control_signal(alu_control_signal)
    );

    assign imm_val_id_ex = memwrite ? {{52{instruction[31]}}, instruction[31:25], instruction[11:7]}  // Store
                                    : {{52{instruction[31]}}, instruction[31:20]};  // Load

    assign immediate = (alu_control_signal == 4'b0010) ? imm_val_id_ex :
                    (alu_control_signal == 4'b0110) ? {{51{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8]}  // Branch
                                                    : 64'd0;


    assign invRegAddr = (rs1 > 5'd31) | (rs2 > 5'd31);
    assign rd1 = rd1_id_ex;
    assign w1 = rd2_id_ex;
    
    assign rd2 = (alusrc_id_ex) ? immediate : w1;

    MUX3 mux3_alu_in1 (
        .in0(rd1),
        .in1(wd),
        .in2(alu_result_ex_mem),
        .sel(ForwardA),
        .out(alu_in1)
    );

    MUX3 mux3_alu_in2 (
        .in0(rd2),
        .in1(wd),
        .in2(alu_result_ex_mem),
        .sel(ForwardB),
        .out(alu_in2)
    );

    // Execute Stage
    wire [63:0] alu_output, next_PC;
    
    execute execute_unit (
        .alu_control_signal(alu_control_id_ex),
        .rd1(alu_in1),
        .rd2(alu_in2),
        .PC(pc_id_ex),
        .immediate(imm_val_id_ex),
        .Branch(branch_id_ex),
        .alu_output(alu_output),
        .next_PC(next_PC)
    );

    wire [63:0] pc_ex_mem;
    wire [31:0] alu_result_ex_mem, read_data2_ex_mem;
    wire [4:0] write_reg_ex_mem;
    wire branch_ex_mem, memwrite_ex_mem, memread_ex_mem, memtoreg_ex_mem, regwrite_ex_mem;

    EX_MEM_Reg ex_mem_register (
        .clk(clock),
        .rst(reset),
        .pc_in(next_PC),
        .zero_in(alu_output == 0),
        .alu_result_in(alu_output[31:0]),
        .read_data2_in(rd2_id_ex[31:0]),
        .write_reg_in(write_reg_id_ex),
        .branch_in(branch_id_ex),
        .memwrite_in(memwrite_id_ex),
        .memread_in(memread_id_ex),
        .memtoreg_in(memtoreg_id_ex),
        .regwrite_in(regwrite_id_ex),
        .pc_out(pc_ex_mem),
        .alu_result_out(alu_result_ex_mem),
        .read_data2_out(read_data2_ex_mem),
        .write_reg_out(write_reg_ex_mem),
        .branch_out(branch_ex_mem),
        .memwrite_out(memwrite_ex_mem),
        .memread_out(memread_ex_mem),
        .memtoreg_out(memtoreg_ex_mem),
        .regwrite_out(regwrite_ex_mem)
    );

    wire [1:0] ForwardA, ForwardB;

    Forwarding_Unit fwdunit(
        .ID_EX_Rs1(register_rs1_id_ex),
        .ID_EX_Rs2(register_rs2_id_ex),
        .EX_MEM_Rd(write_reg_ex_mem),
        .MEM_WB_Rd(write_reg_mem_wb),
        .EX_MEM_RegWrite(regwrite_ex_mem),
        .MEM_WB_RegWrite(regwrite_mem_wb),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB)
    );
    
    wire invMemAddr;

    // Memory Access Stage
    memory_access MEM_stage (
        .MemWrite(memwrite_ex_mem),
        .MemRead(memread_ex_mem),
        .MemtoReg(memtoreg_ex_mem),
        .address(alu_result_ex_mem),
        .invMemAddr(invMemAddr)
    );

    reg [63:0] read_data;
    always @(*) begin
        if (~invMemAddr)  begin
            if (memread_ex_mem) 
                read_data <= data_memory[alu_result_ex_mem / 8]; // Read from memory
            else if (memwrite_ex_mem & !invMemAddr)
                data_memory[alu_result_ex_mem / 8] <= w1;    
        end
    end

    MEM_WB_Reg mem_wb_register (
        .clk(clock),
        .rst(reset),
        .alu_result_in(alu_result_ex_mem),
        .read_data_in(read_data),
        .write_reg_in(write_reg_ex_mem),
        .memtoreg_in(memtoreg_ex_mem),
        .regwrite_in(regwrite_ex_mem),
        .alu_result_out(alu_result_mem_wb),
        .read_data_out(read_data_mem_wb),
        .write_reg_out(write_reg_mem_wb),
        .memtoreg_out(memtoreg_mem_wb),
        .regwrite_out(regwrite_mem_wb)
    );

    Mux mem_mux (
        .input1(alu_result_mem_wb),
        .input2(read_data_mem_wb),
        .select(memtoreg_mem_wb),
        .out(wd)
    );


    always @(posedge clock) begin
    if (reset)
        PC <= 0;
    else if (PCWrite)
        PC <= next_PC; // or your next-PC logic
    else
        PC <= PC; // or your PC-hold logic
    end

    always @(posedge clock) begin
        if(regwrite_mem_wb & !invRegAddr)
            register[write_reg_mem_wb] <= wd;
    end
    
    
endmodule



