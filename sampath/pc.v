module pc_register(clk,next_pc,pc);
    input clk;              
    input [63:0] next_pc;  
    output reg [63:0] pc;
    
    always @(posedge clk) 
    begin
        pc <= next_pc;  
    end
    
endmodule
