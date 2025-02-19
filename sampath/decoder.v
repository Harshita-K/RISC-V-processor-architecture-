module decoder (alu_control_signal,decoder_output);

    input [3:0] alu_control_signal;
    output reg [9:0] decoder_output;
    
    always @(*) begin
        decoder_output = 10'b0000000001;
        case (alu_control_signal)
            4'b0000: decoder_output = 10'b0000000001;
            4'b0001: decoder_output = 10'b0000000010;
            4'b0010: decoder_output = 10'b0000000100;
            4'b0011: decoder_output = 10'b0000001000;
            4'b0100: decoder_output = 10'b0000010000;
            4'b0101: decoder_output = 10'b0000100000;
            4'b0110: decoder_output = 10'b0001000000;
            4'b0111: decoder_output = 10'b0010000000;
            4'b1000: decoder_output = 10'b0100000000;
            4'b1101: decoder_output = 10'b1000000000;
            default: decoder_output = 10'b0000000001;
        endcase
    end   
endmodule
