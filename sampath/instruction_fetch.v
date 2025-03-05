module instruction_fetch (
    input [63:0] PC,  
    output reg [31:0] instruction,  
    output reg invAddr
);
    reg [31:0] instr_mem [0:1023]; 

    initial begin
        instr_mem[0] = 32'h00550533;  // ADD x10, x10, x5  (Correct)
        instr_mem[1] = 32'h40b50533;  // SUB x10, x10, x11 (Correct)
        instr_mem[2] = 32'h00c57533;  // AND x10, x10, x12 (Correct)
        instr_mem[3] = 32'h00E56FB3;  // OR  x10, x10, x13 (Correct)
        instr_mem[4] = 32'h00A73023;  // LD  x16, 0(x14)   (Incorrect, should be LD not LW)
        instr_mem[5] = 32'h00073583;  // ld  x17, 0(x15)  (Incorrect encoding for SD)
        instr_mem[6] = 32'h00B282B3;  // SUB x10, x10, x11 (Correct)  
    end

    always @(*) begin
        if (PC[1:0] != 0 || PC[63:2] > 1023) begin
            invAddr = 1'b1;
            instruction = 32'hxxxxxxxx;  // Invalid instruction
        end else begin
            invAddr = 1'b0;
            instruction = instr_mem[PC[11:2]];  // Fetch instruction
        end
    end
endmodule

module IF_ID_Reg (
    input wire clk,
    input wire rst,
    input wire [63:0] pc_in,
    input wire [31:0] instruction_in,

    output reg [63:0] pc_out,
    output reg [31:0] instruction_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        pc_out         <= 64'b0;
        instruction_out <= 32'b0;
    end
    else begin
        pc_out         <= pc_in;
        instruction_out <= instruction_in;
    end
end

endmodule
