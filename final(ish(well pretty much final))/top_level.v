module top_level (
    input [17:0] SW,
    input  [3:0] KEY,
    input        CLOCK_50,
    output [17:0] LEDR,
	 output [7:0] LEDG,
    output [6:0]  HEX0, HEX1, HEX2, HEX3, HEX7 // Four 7-segment displays
);

    wire [3:0] difficulty;
	 wire reset;
    wire countdown;
    wire select_mole;
    wire [$clog2(5000)-1:0] timer_value;
    wire [$clog2(5000)-1:0] countdown_timer_value;
    wire play;
	 wire timer_reset;
	 wire wait_flag, easy_flag, medium_flag, hard_flag;
	 wire [4:0] mole_position;
	 wire hit;
	 wire mole_complete;
	 wire [11:0] hit_count;
    wire [17:0] debounced_switches; // Debounced switches
	 
    // Debounce all 18 switches
    genvar i;
    generate
        for (i = 0; i < 18; i = i + 1) begin : debounce_loop
            debounce debouncer(
                .clk(CLOCK_50),
                .button(SW[i]),
                .button_pressed(debounced_switches[i])
            );
        end
    endgenerate
	 
	 //instantiate the debouncer
	 debounce hard_debouncer(
		  .clk(CLOCK_50),
		  .button(~KEY[3]),
		  .button_pressed(play)
	 );

	 //instantiate the debouncer
	 synchroniser sync(
		  .clk(CLOCK_50),
		  .x(play),
		  .y(play_stable)  
	 ); 
	 
	 //instantiate the debouncer
	 debounce hard_debouncer1(
		  .clk(CLOCK_50),
		  .button(~KEY[0]),
		  .button_pressed(KEY0_debounced)
	 );

	 //instantiate the debouncer
	 debounce hard_debouncer2(
		  .clk(CLOCK_50),
		  .button(~KEY[1]),
		  .button_pressed(KEY1_debounced)
	 );

	 //instantiate the debouncer
	 debounce hard_debouncer3(
		  .clk(CLOCK_50),
		  .button(~KEY[2]),
		  .button_pressed(KEY2_debounced)
	 ); 
	 
	 button_change_latch (
		.clk(CLOCK_50),
		.rst_n(reset),
		.button0(KEY0_debounced),
		.button1(KEY1_debounced),
		.button2(KEY2_debounced),
		.difficulty(difficulty)
	 );
	 
	 seven_seg difficulty_display(
		.bcd(gameover_flag ? 6'b111111 : difficulty),
		.segments(HEX7)
	 );
	 
	 	 
	 // Instantiate the countdown timer for the SETUP state
	 countdown_timer countdown_timer(
		  .clk(CLOCK_50),
		  .reset(reset),
		  .enable(wait_flag),
		  .timer_value(countdown_timer_value),
		  .end_reached(countdown_complete)
	 );
	 
    // Instantiate the Timer
    timer mole_timer (
        .clk(CLOCK_50),
        .reset(timer_reset | reset),
        .difficulty(difficulty), // Set difficulty as needed
        .end_value(2000), // 1000ms for mole display, 2000ms for countdown
        .enable(play_flag),
        .end_reached(mole_complete),
		  .timer_value(timer_value)
    );
    
    // Instantiate the FSM
    reaction_time_fsm fsm (
        .clk(CLOCK_50),
        .play(play_stable),
        .reset(reset),
		  .countdown_complete(countdown_complete),
		  .mole_complete(mole_complete),
		  .wait_flag(wait_flag),
		  .play_flag(play_flag),
		  .new_mole(new_mole),
		  .score(hit_count),
		  .gameover_flag(gameover_flag)
    );
    
    topRand mole_light (
        .clk(CLOCK_50),
        .reset(reset),
		  .mole_hit(hit),
        .trigger(new_mole),
        .displayL(LEDR),
		  .position(mole_position)
    );
	 
	// Instantiate the hammer module
	hammer hammer_inst(
		 .clk(CLOCK_50),
		 .reset(reset),
		 .mole_position(mole_position),
		 .switches(debounced_switches),
		 .hit(hit),
		 .hit_count(hit_count),
	);
	 
    // Instantiate the Display
    display timer_display (
        .clk(CLOCK_50),
        .value(wait_flag ? countdown_timer_value : hit_count), // Show countdown_timer_value if in WAIT state, otherwise show hit_count
        .display0(HEX0),
        .display1(HEX1),
        .display2(HEX2),
        .display3(HEX3)
    );

	 
endmodule

// additional modules

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

module countdown_timer #(
    parameter MAX_MS = 3000,            // Maximum millisecond value
    parameter CLKS_PER_MS = 50000       // Number of clock cycles in a millisecond
) (
    input                        clk,
    input                        reset,          // Reset timer_value, count, and end_reached to 0
    input                        enable,         // Toggle timer on/off
    output reg [$clog2(MAX_MS)-1:0] timer_value,
    output reg                    end_reached
);

    reg [$clog2(CLKS_PER_MS)-1:0] count;

    always @(posedge clk) begin
        // If reset is high, initialize timer
        if (reset) begin    
            count <= 0;
            timer_value <= MAX_MS; // Initialize to 5000 ms
            end_reached <= 0;
        end
        // If timer is enabled, decrement timer_value
        else if (enable) begin
            // If the clock has counted one ms
            if(count == CLKS_PER_MS - 1) begin
                // Set clock counter back to 0
                count <= 0;
                
                // Decrement timer_value
                if (timer_value > 0) begin
                    timer_value <= timer_value - 1;
                end
                
                // Raise end_reached flag when timer_value reaches 0
                if (timer_value == 0) begin
                    end_reached <= 1;
                end
            end
            // Increment clock counter
            else begin
                count <= count + 1;
            end
        end
    end

endmodule


module hammer (
    input clk,
    input reset,
    input [17:0] switches,  // Assume switches[0] corresponds to mole position 0, etc.
    input [4:0] mole_position,  // Current mole position
    output reg hit,  // Signal to indicate that the mole was hit
	 output reg [11:0] hit_count
);
    reg [17:0] prev_switches;  // Register to store the previous state of the switches

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            prev_switches <= 18'b0;
            hit <= 1'b0;
				hit_count <= 0;
        end else begin
            // Detect if the switch corresponding to the mole position has changed state
            if (switches[mole_position] != prev_switches[mole_position]) begin
                hit <= 1'b1;
					 hit_count <= hit_count + 50;
            end else begin
                hit <= 1'b0;
            end
            // Update the previous switches state
            prev_switches <= switches;
        end
    end
endmodule


module button_change_latch (
    input wire clk,               // Clock signal
    input wire rst_n,             // Asynchronous reset (active low)
    input wire button0,           // Push button 0
    input wire button1,           // Push button 1
    input wire button2,           // Push button 2
    output reg [3:0] difficulty   // Output difficulty level: 00=0, 01=1, 10=2
);

    // Registers to store the previous states of the buttons
    reg button0_d, button1_d, button2_d;

    // Always block to detect button state changes and set difficulty
    always @(posedge clk or posedge rst_n) begin
        if (rst_n) begin
            // Reset the latch and difficulty on reset
            button0_d <= 1'b0;
            button1_d <= 1'b0;
            button2_d <= 1'b0;
            difficulty <= 4'b0000;   // Default difficulty
        end else begin
            // Check for changes in each button and set difficulty
            if (button0 != button0_d) begin
                if (button0) begin
                    difficulty <= 4'b0000; // Set difficulty to 0
                end
            end
            if (button1 != button1_d) begin
                if (button1) begin
                    difficulty <= 4'b0001; // Set difficulty to 1
                end
            end
            if (button2 != button2_d) begin
                if (button2) begin
                    difficulty <= 4'b0010; // Set difficulty to 2
                end
            end

            // Update the previous button states
            button0_d <= button0;
            button1_d <= button1;
            button2_d <= button2;
        end
    end

endmodule




 

