module data_memory (clk, address, write_data, MemWrite, MemRead, read_data);

    input clk;
    input [63:0] address;       
    input [63:0] write_data;    
    input MemWrite;             
    input MemRead;              
    output reg [63:0] read_data;

    reg [63:0] memory [0:1023];

    always @(posedge clk) begin
        if (MemWrite) 
            memory[address] <= write_data;
    end
    
    always @(*) begin
        if (MemRead) 
            read_data = memory[address];
        else 
            read_data = 64'b0;
    end
endmodule
