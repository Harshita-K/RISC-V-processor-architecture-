`timescale 1ns/1ps

module instruction_fetch_tb();
  // Outputs from the DUT (Device Under Test)
  wire [31:0] instruction;
  wire invAddr;
  
  // Instantiate the instruction_fetch module
  instruction_fetch dut (
    .instruction(instruction),
    .invAddr(invAddr)
  );
  
  // Test case structure
  reg [63:0] test_pc_values [0:5];
  integer i;
  
  initial begin
    // Load test instructions into instr_mem through the module hierarchy
    dut.instr_mem[0] = 32'h01234567;  // At address 0x00
    dut.instr_mem[1] = 32'h89ABCDEF;  // At address 0x04
    dut.instr_mem[2] = 32'hFEDCBA98;  // At address 0x08
    dut.instr_mem[3] = 32'h76543210;  // At address 0x0C
    dut.instr_mem[4] = 32'hAABBCCDD; // At address 0x28
    
    // Define test PC values
    test_pc_values[0] = 64'h0000000000000000; // Valid, aligned, points to instr_mem[0]
    test_pc_values[1] = 64'h0000000000000004; // Valid, aligned, points to instr_mem[1]
    test_pc_values[2] = 64'h0000000000000008; // Valid, aligned, points to instr_mem[10]
    test_pc_values[3] = 64'h000000000000000C; // Invalid, not word aligned
    test_pc_values[4] = 64'h1000000000000010; // Invalid, upper bits set
    test_pc_values[5] = 64'h1000000000000014; // Invalid, both issues
    
    $display("=== Instruction Fetch Testbench ===");
    $display("PC Value\t\t\tInstruction");
    $display("-----------------\t--------------");
    
    // Run through all test cases
    for (i = 0; i < 6; i = i + 1) begin
      // Set PC value through hierarchy
      dut.PC = test_pc_values[i];
      
      // Wait for combinational logic to settle
      #10;
      
      // Display PC and instruction
      $display("0x%h\t0x%h", test_pc_values[i], instruction);
    end
    
    $display("=== Instruction Fetch Testbench Complete ===");
    $finish;
  end
endmodule