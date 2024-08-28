module diff_display (
    input [1:0] difficulty,    // 2-bit difficulty input
    output [6:0] HEX0,         // Seven-segment display outputs
    output [6:0] HEX1,
    output [6:0] HEX2,
    output [6:0] HEX3
);

    reg [2:0] letter1, letter2, letter3, letter4;

    // Select letters based on the difficulty level
    always @(*) begin
        case (difficulty)
            2'b00: begin // EASY
                letter1 = 3'b000; // E
                letter2 = 3'b001; // A
                letter3 = 3'b010; // S
                letter4 = 3'b011; // Y
            end
            2'b01: begin // HARD
                letter1 = 3'b100; // H
                letter2 = 3'b001; // A
                letter3 = 3'b101; // R
                letter4 = 3'b110; // D
            end
            2'b10: begin // HELL
                letter1 = 3'b100; // H
                letter2 = 3'b000; // E
                letter3 = 3'b111; // L
                letter4 = 3'b111; // L
            end
            default: begin
                letter1 = 3'b110; // 0
                letter2 = 3'b110; // 0
                letter3 = 3'b110; // 0
                letter4 = 3'b110; // 0
            end
        endcase
    end

    // Instantiate seven_seg modules for each letter
    seven_seg seg0 (.letter(letter1), .segments(HEX3)); // Display on HEX3
    seven_seg seg1 (.letter(letter2), .segments(HEX2)); // Display on HEX2
    seven_seg seg2 (.letter(letter3), .segments(HEX1)); // Display on HEX1
    seven_seg seg3 (.letter(letter4), .segments(HEX0)); // Display on HEX0

endmodule
