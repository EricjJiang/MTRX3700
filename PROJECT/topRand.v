module topRand (
    input clk,
    input reset,
    input trigger,
    output reg [17:0] displayL,  // Adjusted to match mole module output
	 output reg [4:0] position
);
	
	 reg [4:0] saved_position;
    wire [4:0] number;
	 wire [17:0] mole_output;
    reg [17:0] saved_output;   // Register to save the output when trigger is active
    reg last_trigger;          // Register to save the last state of trigger

    // Instantiate RNG Module
    rng rng_inst (
        .clk(clk),
        .rst(reset),
        .out(number)
    );
	 
	 
    // Instantiate Mole Module
    mole mole_inst (
        .number(number%18),  // Ensure number is within 0 to 17 range
        .displayL(mole_output)
    );

    // Capture output on trigger edge and hold it until the next trigger
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            saved_output <= 18'b0; // Initialize to all LEDs off
            last_trigger <= 1'b0;
            displayL <= 18'b0;     // Initialize display to all LEDs off
        end else begin
            if (trigger && !last_trigger) begin
                // Rising edge of trigger
                saved_output <= mole_output;
					 saved_position <= number%18;
            end
            last_trigger <= trigger;
            displayL <= saved_output; // Keep displaying the saved output
				position <= saved_position;
        end
    end

endmodule
