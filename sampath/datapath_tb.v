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

    initial begin
        // Initialize clock and reset
        clock = 0;
        reset = 1;
        
        // Print initial state before first cycle
        
        // Load instruction memory manually (Simulated Instruction Fetch)
        uut.fetch_unit.instr_mem[0] = 32'h003100B3; // add x1, x2, x3
        uut.fetch_unit.instr_mem[1] = 32'h40B505B3; // sub x4, x5, x6
        uut.fetch_unit.instr_mem[2] = 32'h00947C33; // and x7, x8, x9
        uut.fetch_unit.instr_mem[3] = 32'h00C5E533; // or x10, x11, x12
        uut.fetch_unit.instr_mem[4] = 32'h00E6A263; // beq x13, x14, 8
        uut.fetch_unit.instr_mem[5] = 32'h0008A783; // ld x15, 0(x16)
        uut.fetch_unit.instr_mem[6] = 32'h01193023; // sd x17, 0(x18)

        $display("Cycle 0:");
        $display("PC: %h", uut.PC);
        $display("IF:  Instruction = %h", uut.fetch_unit.instr_mem[0]);
        $display("------------------------------------------------------");

        #5 reset = 0; // Release reset after some time
        // Run for a few clock cycles to allow pipelining
        repeat (8) begin
            #10;
            $display("Cycle %d:", $time/10);
            $display("PC: %h", uut.PC);
            
            // Fetch Stage
            $display("IF:  Instruction = %h", uut.fetch_unit.instr_mem[uut.PC >> 2]);
            
            // Decode Stage
            $display("ID:  Instruction = %h, Rs1 = %d, Rs2 = %d, Rd = %d", 
                     uut.instruction_if_id, uut.rs1, uut.rs2, uut.write_reg);
            
            // Execute Stage
            $display("EX:  ALU Control = %b, Src1 = %h, Src2 = %h, Result = %h", 
                     uut.alu_control_signal, uut.alu_in1, uut.alu_in2, uut.alu_output);
            
            // Memory Access Stage
            $display("MEM: Address = %h, MemRead = %b, MemWrite = %b, Data = %h",
                     uut.alu_result_ex_mem, uut.memread_ex_mem, uut.memwrite_ex_mem, uut.data_memory[uut.alu_result_ex_mem >> 3]);
            
            // Write Back Stage
            $display("WB:  RegWrite = %b, WriteReg = %d, WriteData = %h", 
                     uut.regwrite_mem_wb, uut.write_reg_mem_wb, uut.wd);
            
            $display("------------------------------------------------------");
        end

        // Stop the simulation
        $finish;
    end
endmodule
