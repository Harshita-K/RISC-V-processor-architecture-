module pc_register(clk,next_pc,pc);
    input clk;              
    input [63:0] next_pc;  
    output reg [63:0] pc;
    
    always @(posedge clk) 
    begin
        pc <= next_pc;  
    end
    
endmodule

module PCMux (PC_update, PC_branch,Branch,next_pc);

    input wire [63:0] PC_update,PC_branch;
    output wire [63:0] next_pc;
    input Branch;
    assign next_pc = Branch ? PC_branch : PC_update; 

endmodule

module RegisterMux (alu_result, read_data,MemtoReg,wd);

    input wire [63:0] alu_result,read_data;
    output wire [63:0] wd;
    input MemtoReg;
    assign wd = MemtoReg ? read_data : alu_result; 
    
endmodule

module ALUMux (rd2, immediate,ALUSrc,b);

    input wire [63:0] rd2,immediate;
    output wire [63:0] b;
    input ALUSrc;
    assign b = ALUSrc ? immediate : rd2; 
    
endmodule
