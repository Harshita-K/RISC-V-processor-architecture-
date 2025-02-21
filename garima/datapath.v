`timescale 1ns / 1ps

module MultiCycleRiscV(
    input wire clk,
    input wire reset
);
    // -----------------------------------------------
    // Memory (Instruction + Data)
    // -----------------------------------------------
    // For simplicity, we model them as separate
    // reg arrays, each synchronous on posedge clk.
    // In real designs, these might be external modules
    // or memories with different interfaces.
    // -----------------------------------------------
    reg [31:0] instr_mem [0:255];
    reg [31:0] data_mem  [0:255];

    // -----------------------------------------------
    // Internal CPU registers (pipeline-like latches)
    // -----------------------------------------------
    reg [31:0] PC;       // Program Counter
    reg [31:0] IR;       // Instruction Register
    reg [31:0] A, B;     // Register file outputs latched
    reg [31:0] ALUOut;   // ALU result latch
    reg [31:0] MDR;      // Memory Data Register (for loads)
    reg [31:0] Imm;      // Sign-extended immediate

    // -----------------------------------------------
    // Wires for submodules (RegisterFile, ALU, etc.)
    // -----------------------------------------------
    wire [31:0] reg_read_data1, reg_read_data2;
    wire [31:0] alu_result;
    wire alu_zero;

    // Break down fields in IR
    wire [6:0]  opcode = IR[6:0];
    wire [4:0]  rd     = IR[11:7];
    wire [2:0]  funct3 = IR[14:12];
    wire [4:0]  rs1    = IR[19:15];
    wire [4:0]  rs2    = IR[24:20];
    wire [6:0]  funct7 = IR[31:25];

    // Control signals from main controller
    wire        Branch, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite;
    wire [1:0]  ALUOp;

    // ALU control signals
    wire [3:0]  ALUControlSignal;

    // Next-state logic signals
    reg [2:0]   state, next_state;
    localparam  S_IF  = 3'd0,
                S_ID  = 3'd1,
                S_EX  = 3'd2,
                S_MEM = 3'd3,
                S_WB  = 3'd4;

    // -----------------------------------------------
    // Register File
    // -----------------------------------------------
    RegisterFile regfile (
        .clk(clk),
        .we(RegWrite),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wd( (MemToReg) ? MDR : ALUOut ),  // Write-back mux
        .rd1(reg_read_data1),
        .rd2(reg_read_data2)
    );

    // -----------------------------------------------
    // ALU and ALU Control
    // -----------------------------------------------
    ALUControl alu_ctrl(
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .operation(ALUControlSignal)
    );

    ALU alu(
        .A(A),
        .B( (ALUSrc) ? Imm : B ),
        .operation(ALUControlSignal),
        .Result(alu_result),
        .Zero(alu_zero)
    );

    // -----------------------------------------------
    // Main Control (generates signals based on opcode)
    // -----------------------------------------------
    Control main_control(
        .opcode(opcode),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemToReg(MemToReg),
        .ALUOp(ALUOp),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite)
    );

    // -----------------------------------------------
    // Immediate Generator
    // -----------------------------------------------
    wire [31:0] imm_gen_out;
    ImmGen imm_gen(
        .instruction(IR),
        .imm(imm_gen_out)
    );

    // -----------------------------------------------
    // State Register
    // -----------------------------------------------
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= S_IF;
        else
            state <= next_state;
    end

    // -----------------------------------------------
    // Main FSM: Next-State Logic
    // -----------------------------------------------
    always @(*) begin
        next_state = state;
        case (state)
            S_IF:  next_state = S_ID;
            S_ID:  next_state = S_EX;
            S_EX: begin
                // Depending on instruction, either go to MEM or WB or jump back to IF
                // R-type / I-type => go to WB
                // BEQ => possibly update PC in EX, then go to IF
                // LW/SW => go to MEM
                if (opcode == 7'b0000011 || opcode == 7'b0100011) // LW or SW
                    next_state = S_MEM;
                else if (opcode == 7'b1100011) // BEQ
                    next_state = S_IF;  // after branch compute, go fetch next
                else
                    next_state = S_WB;  // R-type or I-type (ADDI) => WB
            end
            S_MEM: begin
                // If load, we need to go to WB next (to write MDR into reg)
                // If store, we’re done => go to IF
                if (opcode == 7'b0000011) // LW
                    next_state = S_WB;
                else
                    next_state = S_IF;   // SW
            end
            S_WB: next_state = S_IF;
            default: next_state = S_IF;
        endcase
    end

    // -----------------------------------------------
    // Main FSM: Outputs & Datapath Actions
    // -----------------------------------------------
    always @(posedge clk) begin
        if (reset) begin
            PC <= 0;
            IR <= 0;
            A  <= 0;
            B  <= 0;
            ALUOut <= 0;
            MDR <= 0;
            Imm <= 0;
        end else begin
            case (state)
            //======================
            //  S_IF: Instruction Fetch
            //======================
            S_IF: begin
                IR <= instr_mem[PC[31:2]];  // synchronous read in this toy example
                PC <= PC + 4;               // next PC by default
            end

            //======================
            //  S_ID: Instruction Decode
            //======================
            S_ID: begin
                // Read registers
                A <= reg_read_data1;
                B <= reg_read_data2;
                // Generate immediate
                Imm <= imm_gen_out;
            end

            //======================
            //  S_EX: Execute ALU
            //======================
            S_EX: begin
                // ALU result is combinational output
                // Latch it for later states
                ALUOut <= alu_result;
                // If branch & condition is true, update PC
                if (Branch && alu_zero) begin
                    // For BEQ, PC = PC + (Imm << 1).  (In real RISC-V, B-type offset is always multiples of 2)
                    // But here we do a simplified approach:
                    PC <= PC + (Imm << 1);
                end
            end

            //======================
            //  S_MEM: Memory Access
            //======================
            S_MEM: begin
                if (MemRead) begin
                    // LW
                    MDR <= data_mem[ ALUOut[31:2] ];  // synchronous read
                end
                if (MemWrite) begin
                    // SW
                    data_mem[ ALUOut[31:2] ] <= B;    // synchronous write
                end
            end

            //======================
            //  S_WB: Write Back
            //======================
            S_WB: begin
                // If MemToReg=1 => write MDR to register
                // else write ALUOut to register
                // (The actual register-file write happens automatically
                //  if RegWrite=1, via the regfile module’s always block.)
            end

            endcase
        end
    end

    // -----------------------------------------------
    // Initialize memory (optional, for test/demo)
    // -----------------------------------------------
    integer i;
    initial begin
        // Fill instr_mem with NOP (ADDI x0,x0,0)
        for (i=0; i<256; i=i+1) begin
            instr_mem[i] = 32'h00000013;
            data_mem[i]  = 32'h00000000;
        end

        // Example: Put ADDI x1, x0, 5 at address 0
        instr_mem[0] = 32'b000000000101_00000_000_00001_0010011; // imm=5, rs1=x0, rd=x1
        // ... etc. Load more instructions as desired
    end

endmodule
