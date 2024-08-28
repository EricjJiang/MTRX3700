module top_level (
    input [17:0] SW,
    input  [3:0] KEY,
    input        CLOCK_50,
    output [17:0] LEDR,
    output [6:0]  HEX0, HEX1, HEX2, HEX3 // Four 7-segment displays
);

    wire reset;
	 	 
    wire countdown;
    wire display_enable;
    wire led_on;
    wire [11:0] timer_value;
	 wire play;
	 
    assign play = ~KEY[3];

	 // Instantiate the Timer
    timer countdown_timer (
        .clk(CLOCK_50),
        .reset(reset),
        .difficulty(0), // Set difficulty as needed
        .end_value(2000),
        .enable(countdown),
        .timer_value(timer_value),
        .end_reached()
    );
    
    // Instantiate the FSM
    reaction_time_fsm fsm (
        .clk(CLOCK_50),
        .timer_value(timer_value),
        .play(play),
        .reset(reset),
        .countdown(countdown),
        .display_enable(display_enable),
        .led_on(led_on)
    );



    // Instantiate the Display
    display timer_display (
        .clk(CLOCK_50),
        .value(display_enable ? timer_value : 11'b0), // Show timer_value only in WAIT state
        .display0(HEX0),
        .display1(HEX1),
        .display2(HEX2),
        .display3(HEX3)
    );
	 
	 topRand mole_light (
		  .clk(CLOCK_50),
		  .reset(reset),
		  .trigger(led_on),
		  .displayL(LEDR)
	 );

endmodule

