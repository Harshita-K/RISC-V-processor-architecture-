module RegisterFile(
    input wire clk,
    input wire we,              // write enable
    input wire [4:0] rs1,       // read register 1
    input wire [4:0] rs2,       // read register 2
    input wire [4:0] rd,        // write register
    input wire [31:0] wd,       // write data
    output wire [31:0] rd1,     // read data 1
    output wire [31:0] rd2      // read data 2
);
    reg [31:0] regs [0:31];
    integer i;

    // Initialize registers to 0 (optional)
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            regs[i] = 32'b0;
        end
    end

    // Write on rising edge if we=1 and rd != 0
    always @(posedge clk) begin
        if (we && (rd != 5'b0)) begin
            regs[rd] <= wd;
        end
    end

    // Read is combinational
    assign rd1 = (rs1 == 5'b0) ? 32'b0 : regs[rs1];
    assign rd2 = (rs2 == 5'b0) ? 32'b0 : regs[rs2];
endmodule
