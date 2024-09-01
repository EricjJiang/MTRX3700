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
	 
	 button_change_latch button_change_latch_tb(
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

	 // Instantiate the difficulty difficulty_selector
     difficulty_selector difficulty_inst(
        .clk(CLOCK_50),
        .KEY0_debounced(KEY[0]),
        .KEY1_debounced(KEY[1]),
        .KEY2_debounced(KEY[2]),
        .difficulty(difficulty)
     );
    
endmodule




 
