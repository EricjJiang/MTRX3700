module mole (
    input [4:0] number,     // Input number to determine which LED to light up
    output reg [17:0] displayL // 18 LEDs output
);

    // Initialize displayL to 0
    always @(*) begin
        displayL = 18'b0; // Set all LEDs to off
        
        // Check if number is within valid range (0 to 17)
        if (number < 18) begin
            displayL[number] = 1'b1; // Light up the LED corresponding to the number
        end
    end

endmodule
