module memory_access(
    input MemWrite,
    input MemRead,
    input MemtoReg,
    input [63:0] address,
    output reg invMemAddr
);

    always @(*) begin
        // Default values
        invMemAddr = 0;

        // Check for valid memory address when MemRead or MemWrite is active
        if ((MemRead || MemWrite) && (((address / 8) > 1023) || (address[1:0] != 0))) begin
            invMemAddr = 1;
        end
    end

endmodule

module MEM_WB_Reg (
    input wire clk,
    input wire rst,
    input wire [31:0] alu_result_in,
    input wire [31:0] read_data_in,
    input wire [4:0] write_reg_in,
    input wire memtoreg_in,
    input wire regwrite_in,

    output reg [31:0] alu_result_out,
    output reg [31:0] read_data_out,
    output reg [4:0] write_reg_out,
    output reg memtoreg_out,
    output reg regwrite_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        alu_result_out <= 32'b0;
        read_data_out  <= 32'b0;
        write_reg_out  <= 5'b0;
        memtoreg_out   <= 1'b0;
        regwrite_out   <= 1'b0;
    end else begin
        alu_result_out <= alu_result_in;
        read_data_out  <= read_data_in;
        write_reg_out  <= write_reg_in;
        memtoreg_out   <= memtoreg_in;
        regwrite_out   <= regwrite_in;
    end
end

endmodule

module memory_stage (
    input wire clk,
    input wire rst,
    input wire [63:0] pc_in,
    input wire zero_in,
    input wire [31:0] alu_result_in,
    input wire [31:0] read_data2_in,
    input wire [4:0] write_reg_in,
    input wire branch_in,
    input wire memwrite_in,
    input wire memread_in,
    input wire memtoreg_in,
    input wire regwrite_in,

    output reg [31:0] alu_result_out,
    output reg [31:0] read_data_out,
    output reg [4:0] write_reg_out,
    output reg memtoreg_out,
    output reg regwrite_out
);

    wire [31:0] read_data;
    wire branch_taken;
    
    // Memory Access Unit
    memory mem_access (
        .alu_result(alu_result_in),
        .write_data(read_data2_in),
        .mem_read(memread_in),
        .mem_write(memwrite_in),
        .read_data(read_data)
    );

    // MEM/WB Pipeline Register
    MEM_WB_Reg mem_wb_register (
        .clk(clk),
        .rst(rst),
        .alu_result_in(alu_result_in),
        .read_data_in(read_data),
        .write_reg_in(write_reg_in),
        .memtoreg_in(memtoreg_in),
        .regwrite_in(regwrite_in),
        .alu_result_out(alu_result_out),
        .read_data_out(read_data_out),
        .write_reg_out(write_reg_out),
        .memtoreg_out(memtoreg_out),
        .regwrite_out(regwrite_out)
    );

endmodule