`include "global.v"
`include "MUX.v"
module memory_access(
    input MemWrite,
    input MemRead,
    input MemtoReg,
    input [63:0] address,
    input [63:0] write_data,
    output [63:0] wd
);
    
    reg [63:0] read_data;
    
    always @(*) begin
        if (address >= 0 && address <= 1023) begin
            if (MemRead) 
                read_data = data_mem[address];
            else
                read_data = 64'd0;

            if (MemWrite) 
                data_mem[address] = write_data;
        end else begin
            read_data = 64'd0;
        end
    end

    MUX mem_mux (
        .sel(MemtoReg),
        .in0(address),
        .in1(read_data),
        .out(wd)
    );

endmodule
