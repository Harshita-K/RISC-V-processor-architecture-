`include "global.v"
module write_back(
    input [63:0] alu_result,
    input [63:0] mem_data,
    input MemtoReg,
    output [63:0] write_data
);
    assign write_data = MemtoReg ? mem_data : alu_result;
endmodule