
module datapath_tb();

wire [63:0] rd1, rd2;
wire [4:0] write_addr;
wire [3:0] alu_control_signal;
wire RegWrite, MemRead, MemtoReg, MemWrite, Branch;

// Register file for instruction decode (initialized with sample values)
reg [63:0] registers [31:0];

// PC values for testing
reg [63:0] test_pc_values [0:5];

integer i;

// Instantiate datapath module
datapath dut (
    .rd1(rd1),
    .rd2(rd2),
    .write_addr(write_addr),
    .alu_control_signal(alu_control_signal),
    .RegWrite(RegWrite),
    .MemRead(MemRead),
    .MemtoReg(MemtoReg),
    .MemWrite(MemWrite),
    .Branch(Branch)
);

initial begin
  // Initialize instruction memory inside instruction_fetch module
// RISC-V Instructions for a Testbench
// ADD instruction (x0 = x0 + x0)
dut.IF_stage.instr_mem[0] = 32'h00000033;  // add x0, x0, x0

// SUB instruction (x0 = x0 - x0)
dut.IF_stage.instr_mem[1] = 32'h40000033;  // sub x0, x0, x0

// LD instruction (x1 = MEM[x2 + 16])
dut.IF_stage.instr_mem[2] = 32'h0102B083;  // ld x1, 16(x2)

// SD instruction (MEM[x3 + 8] = x4)
dut.IF_stage.instr_mem[3] = 32'h0041A423;  // sd x4, 8(x3)

// BEQ instruction (if x5 == x6, PC += offset)
dut.IF_stage.instr_mem[4] = 32'h00628A63;  // beq x5, x6, offset(+20)

// OR instruction (x7 = x8 | x9)
dut.IF_stage.instr_mem[5] = 32'h009463B3;  // or x7, x8, x9

// AND instruction (x10 = x11 & x12)
dut.IF_stage.instr_mem[6] = 32'h00C5F533;  // and x10, x11, x12
  // Initialize register file with test values
  for (i = 0; i < 32; i = i + 1) begin
    registers[i] = i * 10; // Register i contains (i * 10)
  end

  // Define test PC values
  test_pc_values[0] = 64'h0000000000000000; 
  test_pc_values[1] = 64'h0000000000000004;
  test_pc_values[2] = 64'h0000000000000008;
  test_pc_values[3] = 64'h000000000000000C;
  test_pc_values[4] = 64'h0000000000000010;
  test_pc_values[5] = 64'h0000000000000014;

  $display("=== Datapath Testbench ===");
  $display("PC Value\tInstruction\tReg1\tReg2\tWrite Addr\tALU Ctrl\tRegWrite\tMemRead\tMemWrite\tBranch");
  $display("-------------------------------------------------------------------------------------------------");

  // Run through all test cases
  for (i = 0; i < 6; i = i + 1) begin
    // Set PC value
    dut.IF_stage.PC = test_pc_values[i];

    // Wait for combinational logic to settle
    #10;

    // Display test results
    $display("0x%b",
            alu_control_signal);
  end

  $display("=== Datapath Testbench Complete ===");
  $finish;
end

endmodule
