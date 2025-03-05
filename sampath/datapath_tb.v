`timescale 1ns/1ps

module datapath_tb;
    reg clock, reset;
    integer i;
    
    // Instantiate the datapath
    datapath uut (
        .clock(clock),
        .reset(reset)
    );

    // Clock generation
    always #5 clock = ~clock;
    
    initial begin
        // Initialize signals
        clock = 0;
        uut.PC = 64'h0;

        
        // Display header
        $display("-------------------------------------------------------------------------------------------------");
        $display("| Cycle |   Pipeline Stage  |      PC      |   Instruction / Data  |");
        $display("-------------------------------------------------------------------------------------------------");
        
        #15;
        $display("|  1    |   IF/ID (Fetch)   |  %h  |  %h  |", uut.PC, uut.instruction_if_id);
        #10;
        $display("|  2    |   ID/EX (Decode)  |  %h  | ALU In1: %2d, ALU In2: %2d, ALU Out: %2d |", uut.pc_id_ex, uut.alu_in1, uut.alu_in2, uut.alu_output);
        #10;
        $display("|  3    |   EX/MEM (Execute)|  %h  | Rd1: %2d, Rd2: %2d|", uut.pc_ex_mem, uut.alu_result_ex_mem, uut.read_data2_ex_mem);
        #10;
        $display("|  4    |   MEM/WB (Memory) |  %h  | Write Address: %2d, MEM Read Data: %2d |", uut.pc_ex_mem, uut.write_reg_ex_mem, uut.read_data2_ex_mem);
        #10;
        $display("|  5    |   WB (Write-Back) |  %h  | WB Register: x%0d, WB Data: %2d |", uut.PC, uut.write_reg_mem_wb, uut.wd);
        #10;
        
        $display("-------------------------------------------------------------------------------------------------");
        
        $finish;
    end
    
endmodule
