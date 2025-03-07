`timescale 1ns/1ps

module datapath_tb;
    reg clock;
    reg reset;

    // Instantiate the datapath module
    datapath uut (
        .clock(clock),
        .reset(reset)
    );

    // Clock Generation (50% Duty Cycle)
    always #5 clock = ~clock;
    
    // Read instructions into the instruction memory of the fetch unit
    initial begin
        $readmemb("instructions.txt", uut.fetch_unit.instr_mem);
    end

    initial begin
        // Initialize clock and reset
        clock = 0;
        reset = 1;
        
        // Initial display at Cycle 0
        $display("Cycle 0:");
        $display("------------------------------------------------------");
        // IF Stage (Fetch)
        $display("IF Stage:");
        $display("  PC = %h", uut.PC);
        $display("  Instruction (from instr_mem[%0d]) = %h", uut.PC >> 2, uut.fetch_unit.instr_mem[uut.PC >> 2]);
        // IF/ID Register outputs
        $display("IF/ID Register:");
        $display("  PC (pc_if_id) = %h", uut.pc_if_id);
        $display("  Instruction (instruction_if_id) = %h", uut.instruction_if_id);
        // ID Stage (Decode)
        $display("ID Stage:");
        $display("  Instruction = %h", uut.instruction_if_id);
        $display("  Rs1 = %d, Rs2 = %d, Rd = %d", uut.rs1, uut.rs2, uut.write_reg);
        // ID/EX Register outputs
        $display("ID/EX Register:");
        $display("  PC (pc_id_ex) = %h", uut.pc_id_ex);
        $display("  Read Data1 (rd1_id_ex) = %h", uut.rd1_id_ex);
        $display("  Read Data2 (rd2_id_ex) = %h", uut.rd2_id_ex);
        $display("  Immediate Value (imm_val_id_ex) = %h", uut.imm_val_id_ex);
        $display("  ALU Control (alu_control_id_ex) = %b", uut.alu_control_id_ex);
        $display("  ALUSrc = %b", uut.alusrc_id_ex); // or uut.alusrc_id_ex if defined
        $display("  Branch = %b", uut.branch_id_ex);
        $display("  MemWrite = %b, MemRead = %b, MemtoReg = %b, RegWrite = %b", uut.memwrite_id_ex, uut.memread_id_ex, uut.memtoreg_id_ex, uut.regwrite_id_ex);
        $display("  Rs1 (register_rs1_id_ex) = %d, Rs2 (register_rs2_id_ex) = %d", uut.register_rs1_id_ex, uut.register_rs2_id_ex);
        $display("  ALU Op (alu_op_id_ex) = %b", uut.alu_op_id_ex);
        // EX Stage (Execute)
        $display("EX Stage:");
        $display("  ALU Control Signal = %b", uut.alu_control_signal);
        $display("  ALU Input1 (alu_in1) = %h", uut.alu_in1);
        $display("  ALU Input2 (alu_in2) = %h", uut.alu_in2);
        $display("  ALU Output (alu_output) = %h", uut.alu_output);
        // EX/MEM Register outputs
        $display("EX/MEM Register:");
        $display("  PC (pc_ex_mem) = %h", uut.pc_ex_mem);
        $display("  Zero Flag (zero flag) = %b", uut.zer0_ex_mem);
        $display("  ALU Result (alu_result_ex_mem) = %h", uut.alu_result_ex_mem);
        $display("  Write Reg (write_reg_ex_mem) = %d", uut.write_reg_ex_mem);
        $display("  Branch = %b, MemWrite = %b, MemRead = %b, MemtoReg = %b, RegWrite = %b", uut.branch_ex_mem, uut.memwrite_ex_mem, uut.memread_ex_mem, uut.memtoreg_ex_mem, uut.regwrite_ex_mem);
        // MEM Stage (Memory Access)
        $display("MEM Stage:");
        $display("  Read Data (read_data) = %h", uut.read_data);
        $display("  Memory Address (alu_result_ex_mem) = %h", uut.alu_result_ex_mem);
        $display("  MemRead = %b, MemWrite = %b", uut.memread_ex_mem, uut.memwrite_ex_mem);
        // MEM/WB Register outputs
        $display("MEM/WB Register:");
        $display("  ALU Result (alu_result_mem_wb) = %h", uut.alu_result_mem_wb);
        $display("  Read Data (read_data_mem_wb) = %h", uut.read_data_mem_wb);
        $display("  Write Reg (write_reg_mem_wb) = %d", uut.write_reg_mem_wb);
        $display("  MemtoReg = %b, RegWrite = %b", uut.memtoreg_mem_wb, uut.regwrite_mem_wb);
        // WB Stage (Write Back)
        $display("WB Stage:");
        $display("  Write Data (wd) = %h", uut.wd);
        $display("------------------------------------------------------");

        #5 reset = 0; // Release reset

        // Run for a few clock cycles to allow pipelining
        repeat (9) begin
            #10; // Advance one full clock period (10ns)
            $display("Cycle %d:", $time/10);
            
            // IF Stage
            $display("IF Stage:");
            $display("  PC = %h", uut.PC);
            $display("  Instruction (from instr_mem[%0d]) = %h", uut.PC >> 2, uut.fetch_unit.instr_mem[uut.PC >> 2]);
            $display("IF/ID Register:");
            $display("  PC (pc_if_id) = %h", uut.pc_if_id);
            $display("  Instruction (instruction_if_id) = %h", uut.instruction_if_id);
            
            // ID Stage
            $display("ID Stage:");
            $display("  Instruction = %h", uut.instruction_if_id);
            $display("  Rs1 = %d, Rs2 = %d, Rd = %d", uut.rs1, uut.rs2, uut.write_reg);
            $display("  Immediate Value (imm_val) = %h", uut.imm_val);
            $display("  Immediate Value (immediate) = %h", uut.immediate);
            $display("  ALUSrc = %b", uut.alusrc_after_stall);
            $display("  Branch = %b", uut.branch);
            $display("  invalid = %b", uut.invOp);
            $display("  stall = %b", uut.stall);
            $display("  only from control unit: MemWrite = %b, MemRead = %b, MemtoReg = %b, RegWrite = %b", uut.memwrite, uut.memread, uut.memtoreg, uut.regwrite);
            $display("ID/EX Register:");
            $display("  PC (pc_id_ex) = %h", uut.pc_id_ex);
            $display("  Read Data1 (rd1_id_ex) = %h", uut.rd1_id_ex);
            $display("  Read Data2 (rd2_id_ex) = %h", uut.rd2_id_ex);
            $display("  Immediate Value (imm_val_id_ex) = %h", uut.imm_val_id_ex);
            $display("  ALU Control (alu_control_id_ex) = %b", uut.alu_control_id_ex);
            $display("  ALUSrc = %b", uut.alusrc_id_ex);
            $display("  Branch = %b", uut.branch_id_ex);
            $display("  invalid = %b", uut.invOp);
            $display("  MemWrite = %b, MemRead = %b, MemtoReg = %b, RegWrite = %b", uut.memwrite_id_ex, uut.memread_id_ex, uut.memtoreg_id_ex, uut.regwrite_id_ex);
            $display("  Rs1 (register_rs1_id_ex) = %d, Rs2 (register_rs2_id_ex) = %d", uut.register_rs1_id_ex, uut.register_rs2_id_ex);
            $display("  ALU Op (alu_op_id_ex) = %b", uut.alu_op_id_ex);
            
            // EX Stage
            $display("EX Stage:");
            $display("  ALU Control Signal = %b", uut.alu_control_signal);
            $display("  ALU Input1 (alu_in1) = %h", uut.alu_in1);
            $display("  ALU Input2 (alu_in2) = %h", uut.alu_in2);
            $display("  ALU Output (alu_output) = %h", uut.alu_output);
            $display("EX/MEM Register:");
            $display("  PC (pc_ex_mem) = %h", uut.pc_ex_mem);
            $display("  Zero Flag (zero flag) = %b", uut.zer0_ex_mem);
            $display("  ALU Result (alu_result_ex_mem) = %h", uut.alu_result_ex_mem);
            $display("  Write Reg (write_reg_ex_mem) = %d", uut.write_reg_ex_mem);
            $display("  invalid address = %d", uut.invMemAddr);
            $display("  Branch = %b, MemWrite = %b, MemRead = %b, MemtoReg = %b, RegWrite = %b", uut.branch_ex_mem, uut.memwrite_ex_mem, uut.memread_ex_mem, uut.memtoreg_ex_mem, uut.regwrite_ex_mem);
        end

        // Stop the simulation
        $finish;
    end
endmodule
