module instruction_fetch (
    input [63:0] PC,  
    output reg [31:0] instruction,  
    output reg invAddr
);
    reg [31:0] instr_mem [0:1023]; 

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
    input branch_signal,
    input wire [63:0] pc_in,
    input wire [31:0] instruction_in,

    output reg [63:0] pc_out,
    output reg [31:0] instruction_out
);

always @(posedge clk or posedge rst) begin
    if (rst | branch_signal) begin
        pc_out         <= 64'b0;
        instruction_out <= 32'b0;
    end
    else begin
        pc_out         <= pc_in;
        instruction_out <= instruction_in;
    end
end

endmodule
