module difficulty_selector (
    input wire clk,
    input wire KEY0_debounced, // Hard
    input wire KEY1_debounced, // Medium
    input wire KEY2_debounced, // Easy
    output reg [3:0] difficulty // Difficulty level: 00=Easy, 01=Medium, 10=Hard
);

    always @(*) begin
        // Default to '0' if no button is pressed
        difficulty = 4'b0000; 

        case (1'b1)
				KEY2_debounced: difficulty = 4'b0000; // Easy
            KEY1_debounced: difficulty = 4'b0001; // Medium
            KEY0_debounced: difficulty = 4'b0010; // Hard
        endcase
    end

endmodule
