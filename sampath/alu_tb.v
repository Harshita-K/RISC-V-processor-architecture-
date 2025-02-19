module ALU_tb;
    reg [63:0] a;
    reg [63:0] b;
    reg [31:0] instruction;
    wire [63:0] Output;

    ALU uut (.a(a),.b(b),.instruction(instruction),.Output(Output));

    initial begin
        $dumpfile("file.vcd");
        $dumpvars(0, ALU_tb);
        $display("Testing ADD operation:");
        a = 64'd4294967296;
        b = 64'd8; 
        instruction = 32'b00000000011000101000001110110011;
        #10;
        $display("a = %d\t\tb = %d\t\tresult = %d", $signed(a), $signed(b), $signed(Output));

        $display("Testing SUB operation:");
        instruction = 32'b01000000011000101000001110110011;
        #10;
        $display("a = %d\t\tb = %d\t\tresult = %d", $signed(a), $signed(b), $signed(Output));

        $display("Testing SLL operation:");
        instruction = 32'b0000000001110011001001010110011;
        #10;
        $display("a = %h\t\tb = %h\t\tresult = %h", a, b, Output);

        $display("Testing SRL operation:");
        instruction = 32'b0000000001110011101001010110011;
        #10;
        $display("a = %h\t\tb = %h\t\tresult = %h", a, b, Output);

        $display("Testing SRA operation:");
        instruction = 32'b01000000011110011101001010110011;
        #10;
        $display("a = %h\t\tb = %h\t\tresult = %h", a, b, Output);

        $display("Testing SLT operation:");
        instruction = 32'b0000000001110011010001010110011;
        #10;
        $display("a = %d\t\tb = %d\t\tresult = %d", $signed(a), $signed(b), Output);

        $display("Testing SLTU operation:");
        instruction = 32'b0000000001110011011001010110011;
        #10;
        $display("a = %d\t\tb = %d\t\tresult = %d", a, b, Output);

        $display("Testing OR operation:");
        instruction = 32'b0000000001110011110001010110011;
        #10;
        $display("a = %h\t\tb = %h\t\tresult = %h", a, b, Output);

        $display("Testing AND operation:");
        instruction = 32'b0000000001110011111001010110011;
        #10;
        $display("a = %h\t\tb = %h\t\tresult = %h", a, b, Output);

        $display("Testing XOR operation:");
        instruction = 32'b0000000001110011100001010110011;
        #10;
        $display("a = %h\t\tb = %h\t\tresult = %h", a, b, Output);

        $finish;
    end

endmodule
