module diff_display (
    input [1:0] miss,    // 2-bit difficulty input
    output [6:0] HEX4,         // Seven-segment display outputs
);

    reg miss_display;

    // Select letters based on the difficulty level
    always @(*) begin
        case (miss)
            2'b00: miss_display = 2'b00; // 0 miss
            2'b01: miss_display = 2'b01; // 1 miss
            2'b10: miss_display = 2'b10; // 2 misses
            2'b11: miss_display = 2'b11; // 3 misses
        endcase
    end

    // Instantiate seven_seg modules for each letter
    seven_seg seg0 (.miss(miss_display), .segments(HEX4)); // Display on HEX4
endmodule
