module seven_seg (
    input      [3:0]  bcd,
    output reg [6:0]  segments // Must be reg to set in always block!!
);

    always @(bcd) begin
        case (bcd)
            4'b0000: segments = 7'b1000000; // 0
            4'b0001: segments = 7'b1111001; // 1
            4'b0010: segments = 7'b0100100; // 2
            4'b0011: segments = 7'b0110000; // 3
            4'b0100: segments = 7'b0011001; // 4
            4'b0101: segments = 7'b0010010; // 5
            4'b0110: segments = 7'b0000010; // 6
            4'b0111: segments = 7'b1111000; // 7
            4'b1000: segments = 7'b0000000; // 8
            4'b1001: segments = 7'b0010000; // 9
            default: segments = 7'b1111111; // Turn off all segments
        endcase   
    end

    always @(difficulty)begin
        case(letter)
            E: segments = 7'b0000110;
            A: segments = 7'b0001000;
            S: segments = 7'b0010010;
            Y: segments = 7'b0010001;
            H: segments = 7'b0001001;
            R: segments = 7'10011110;
            D: segments = 7'b1000000;
            L: segments = 7'b1000111;
        endcase
    end

endmodule
