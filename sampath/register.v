module RegisterFile (clk, write_enable, rs1, rs2, rd, wd, rd1, rd2);
    
    input wire clk;
    input wire write_enable;
    input wire [4:0] rs1;
    input wire [4:0] rs2;
    input wire [4:0] rd;
    input wire [63:0] wd;
    output wire [63:0] rd1;
    output wire [63:0] rd2;
    
    reg [63:0] register [31:0];

    assign rd1 = register[rs1];
    assign rd2 = register[rs2];

    initial 
    begin
        register[0] = 64'b0;
    end

    always @(posedge clk) 
    begin
        if (write_enable == 1 && rd != 5'b00000)       
            register[rd] <= wd;
    end

endmodule
