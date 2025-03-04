module EX_MEM_Reg (
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
    
    output reg [63:0] pc_out,
    output reg zero_out,
    output reg [31:0] alu_result_out,
    output reg [31:0] read_data2_out,
    output reg [4:0] write_reg_out,
    output reg branch_out,
    output reg memwrite_out,
    output reg memread_out,
    output reg memtoreg_out,
    output reg regwrite_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        pc_out         <= 64'b0;
        zero_out       <= 1'b0;
        alu_result_out <= 32'b0;
        read_data2_out <= 32'b0;
        write_reg_out  <= 5'b0;
        branch_out     <= 1'b0;
        memwrite_out   <= 1'b0;
        memread_out    <= 1'b0;
        memtoreg_out   <= 1'b0;
        regwrite_out   <= 1'b0;
    end else begin
        pc_out         <= pc_in;
        zero_out       <= zero_in;
        alu_result_out <= alu_result_in;
        read_data2_out <= read_data2_in;
        write_reg_out  <= write_reg_in;
        branch_out     <= branch_in;
        memwrite_out   <= memwrite_in;
        memread_out    <= memread_in;
        memtoreg_out   <= memtoreg_in;
        regwrite_out   <= regwrite_in;
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
    end else begin
        pc_out         <= pc_in;
        instruction_out <= instruction_in;
    end
end

endmodule

module ID_EX_Reg (
    input wire clk,
    input wire rst,
    input wire [63:0] pc_in,
    input wire [31:0] read_data1_in,
    input wire [31:0] read_data2_in,
    input wire [63:0] imm_val_in,
    input wire [4:0] write_reg_in,
    input wire [9:0] alu_control_in,
    input wire alusrc_in,
    input wire branch_in,
    input wire memwrite_in,
    input wire memread_in,
    input wire memtoreg_in,
    input wire regwrite_in,

    output reg [63:0] pc_out,
    output reg [31:0] read_data1_out,
    output reg [31:0] read_data2_out,
    output reg [63:0] imm_val_out,
    output reg [4:0] write_reg_out,
    output reg [9:0] alu_control_out,
    output reg alusrc_out,
    output reg branch_out,
    output reg memwrite_out,
    output reg memread_out,
    output reg memtoreg_out,
    output reg regwrite_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        pc_out         <= 64'b0;
        read_data1_out <= 32'b0;
        read_data2_out <= 32'b0;
        imm_val_out    <= 64'b0;
        write_reg_out  <= 5'b0;
        alu_control_out <= 10'b0;
        alusrc_out     <= 1'b0;
        branch_out     <= 1'b0;
        memwrite_out   <= 1'b0;
        memread_out    <= 1'b0;
        memtoreg_out   <= 1'b0;
        regwrite_out   <= 1'b0;
    end else begin
        pc_out         <= pc_in;
        read_data1_out <= read_data1_in;
        read_data2_out <= read_data2_in;
        imm_val_out    <= imm_val_in;
        write_reg_out  <= write_reg_in;
        alu_control_out <= alu_control_in;
        alusrc_out     <= alusrc_in;
        branch_out     <= branch_in;
        memwrite_out   <= memwrite_in;
        memread_out    <= memread_in;
        memtoreg_out   <= memtoreg_in;
        regwrite_out   <= regwrite_in;
    end
end

endmodule
