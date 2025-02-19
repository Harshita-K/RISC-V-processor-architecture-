module memory_unit (
    input wire clk,
    input wire rst,
    input wire [31:0] addr,      // Memory address
    input wire [31:0] write_data, // Data to write
    input wire mem_read,         // Memory read control signal
    input wire mem_write,        // Memory write control signal
    input wire [2:0] funct3,     // Function3 field from instruction
    output reg [31:0] read_data, // Data read from memory
    output reg mem_ready         // Memory operation complete signal
);

    // Memory array (4KB for this example)
    reg [7:0] memory [0:4095];  // Byte-addressable memory
    
    // Internal signals for handling different memory access types
    reg [31:0] aligned_addr;
    reg [31:0] word_data;
    reg [15:0] half_data;
    reg [7:0] byte_data;

    // Memory operation handling
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            read_data <= 32'b0;
            mem_ready <= 1'b0;
        end else begin
            mem_ready <= 1'b1;
            aligned_addr = {addr[31:2], 2'b00};  // Word-aligned address

            // Memory read operations
            if (mem_read) begin
                case (funct3)
                    // LB (Load Byte)
                    3'b000: begin
                        byte_data = memory[addr];
                        read_data = {{24{byte_data[7]}}, byte_data};
                    end
                    
                    // LH (Load Halfword)
                    3'b001: begin
                        half_data = {memory[addr+1], memory[addr]};
                        read_data = {{16{half_data[15]}}, half_data};
                    end
                    
                    // LW (Load Word)
                    3'b010: begin
                        read_data = {memory[addr+3], memory[addr+2], 
                                   memory[addr+1], memory[addr]};
                    end
                    
                    // LBU (Load Byte Unsigned)
                    3'b100: begin
                        read_data = {24'b0, memory[addr]};
                    end
                    
                    // LHU (Load Halfword Unsigned)
                    3'b101: begin
                        read_data = {16'b0, memory[addr+1], memory[addr]};
                    end
                    
                    default: read_data = 32'b0;
                endcase
            end

            // Memory write operations
            if (mem_write) begin
                case (funct3)
                    // SB (Store Byte)
                    3'b000: begin
                        memory[addr] = write_data[7:0];
                    end
                    
                    // SH (Store Halfword)
                    3'b001: begin
                        memory[addr] = write_data[7:0];
                        memory[addr+1] = write_data[15:8];
                    end
                    
                    // SW (Store Word)
                    3'b010: begin
                        memory[addr] = write_data[7:0];
                        memory[addr+1] = write_data[15:8];
                        memory[addr+2] = write_data[23:16];
                        memory[addr+3] = write_data[31:24];
                    end
                endcase
            end
        end
    end

endmodule