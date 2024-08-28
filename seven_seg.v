module seven_seg (
    input      [3:0]  bcd,
    input      [2:0] letter;
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

    always @(letter)begin
        case (letter)
            3'b000: segments = 7'b0000110; // E
            3'b001: segments = 7'b0001000; // A
            3'b010: segments = 7'b0010010; // S
            3'b011: segments = 7'b0010001; // Y
            3'b100: segments = 7'b0001001; // H
            3'b101: segments = 7'10011110; // R
            3'b110: segments = 7'b1000000; // D
            3'b111: segments = 7'b1000111; // E
            default: segments = 7'b1111111; // Turn off all segments
        endcase
    end

endmodule
