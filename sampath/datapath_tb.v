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
            $readmemb("instructions.txt", uut.fetch_unit.instr_mem);
    end
    initial begin
        // Initialize clock and reset
        clock = 0;
        reset = 1;
        
        

        $display("Cycle 0:");
        $display("PC: %h", uut.PC);
        $display("IF:  Instruction = %h", uut.fetch_unit.instr_mem[uut.PC >> 2]);
        $display("ID:  Instruction = %h, Rs1 = %d, Rs2 = %d, Rd = %d", 
                     uut.instruction_if_id, uut.rs1, uut.rs2, uut.write_reg);
            
            // Execute Stage
            $display("EX:  ALU Control = %b, Alu_in1 = %h, Alu_in2 = %h, Alu_output = %h", 
                     uut.alu_control_signal, uut.alu_in1, uut.alu_in2, uut.alu_output);
            
            // Memory Access Stage
            $display("MEM: Address = %h, MemRead = %b, MemWrite = %b, Data = %h",
                     uut.alu_result_ex_mem, uut.memread_ex_mem, uut.memwrite_ex_mem, uut.data_memory[uut.alu_result_ex_mem >> 3]);
            
            // Write Back Stage
            $display("WB:  RegWrite = %b, WriteReg = %d, WriteData = %h", 
                     uut.regwrite_mem_wb, uut.write_reg_mem_wb, uut.wd);
            
            $display("------------------------------------------------------");

        #5 reset = 0; // Release reset after some time
        // Run for a few clock cycles to allow pipelining
        repeat (13) begin
            #10;
            $display("Cycle %d:", $time/10);
            $display("PC: %h", uut.PC);
            
            // Fetch Stage
            $display("IF:  Instruction = %b", uut.fetch_unit.instr_mem[uut.PC >> 2]);
            
            // Decode Stage
            $display("ID:  Instruction = %h, Rs1 = %d, Rs2 = %d, Rd = %d", 
                     uut.instruction_if_id, uut.rs1, uut.rs2, uut.write_reg);
            
            // Execute Stage
            $display("EX:  ALU Control = %b, Alu_in1 = %h, Alu_in2 = %h, Alu_output = %h", 
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
