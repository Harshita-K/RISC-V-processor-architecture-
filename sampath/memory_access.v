module memory_access(
    input MemWrite,
    input MemRead,
    input MemtoReg,
    input [63:0] address,
    input [63:0] write_data,
    inout [63:0] data_memory [0:1023], // Bidirectional data memory
    output [63:0] wd
);
    
    reg [63:0] read_data;
    
    always @(*) begin
        if (address >= 0 && address <= 1023) begin
            if (MemRead) 
                read_data = data_memory[address]; // Read from memory
            else
                read_data = 64'd0; // Default value when not reading

            if (MemWrite) 
                data_memory[address] = write_data; // Write to memory
        end else begin
            read_data = 64'd0; // Address out of range
        end
    end

    // MUX to select between read_data and address based on MemtoReg
    Mux mem_mux (
        .input1(address),
        .input2(read_data),
        .select(MemtoReg),
        .out(wd)
    );

endmodule
