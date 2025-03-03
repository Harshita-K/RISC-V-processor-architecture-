module memory_access(
    input MemWrite,
    input MemRead,
    input MemtoReg,
    input [63:0] address,
    input [63:0] write_data,
    output reg [63:0] read_data,
    output reg invMemAddr
);

    reg [63:0] data_memory [0:1023]; // Define the memory

    always @(*) begin
        // Default values
        invMemAddr = 0;
        read_data = 64'd0;

        // Check for valid memory address when MemRead or MemWrite is active
        if ((MemRead || MemWrite) && (address > 1023)) begin
            invMemAddr = 1;
        end else begin
            if (MemRead) 
                read_data = data_memory[address]; // Read from memory
            
            if (MemWrite) 
                data_memory[address] = write_data; // Write to memory
        end
    end

endmodule
