module top_level (
    input [17:0] SW,
    input  [3:0] KEY,
    input        CLOCK_50,
    output [17:0] LEDR,
	 output [7:0] LEDG,
    output [6:0]  HEX0, HEX1, HEX2, HEX3, HEX5, HEX7 // Four 7-segment displays
);

    wire [3:0] difficulty;
	 wire reset;
    wire countdown;
    wire display_enable;
    wire led_on;
    wire select_mole;
    wire [$clog2(5000)-1:0] timer_value;
    wire play;
	 wire timer_reset;
	 wire wait_flag, easy_flag, medium_flag, hard_flag;
	 wire [4:0] mole_position;
	 wire HIT;
	 wire edge_detected;
	 wire edge_detected_stable;
	 
	 
	 //instantiate the debouncer
	 debounce play_debouncer(
		  .clk(CLOCK_50),
		  .button(~KEY[3]),
		  .button_pressed(play)
		  
	 );
	 
	 //instantiate the debouncer
	 debounce easy_debouncer(
		  .clk(CLOCK_50),
		  .button(~KEY[2]),
		  .button_pressed(KEY2_debounced)
		  
	 );
	 
	 //instantiate the debouncer
	 debounce medium_debouncer(
		  .clk(CLOCK_50),
		  .button(~KEY[1]),
		  .button_pressed(KEY1_debounced)
		  
	 );
	 
	 //instantiate the debouncer
	 debounce hard_debouncer(
		  .clk(CLOCK_50),
		  .button(~KEY[0]),
		  .button_pressed(KEY0_debounced)
		  
	 );

	 //instantiate the debouncer
	 synchroniser sync(
		  .clk(CLOCK_50),
		  .x(play),
		  .y(play_stable)  
	 ); 
	 
        
    edge_det edge_det0 (
        .clk(CLOCK_50),
        .signal(play_flag),
        .edge_detected(edge_detected)
    );
	 
	 //instantiate the debouncer
	 synchroniser sync2(
		  .clk(CLOCK_50),
		  .x(edge_detected),
		  .y(edge_detected_stable)  
	 ); 
	 
	 assign LEDG[0] = edge_detected;
	 assign LEDG[1] = play_flag;
	 
	 wire [3:0] edge_bcd;
	 assign edge_bcd = {3'b000, edge_detected_stable};  // Use `edge_detected` as the least significant bit
	 
	 
	 
	 // Instantiate the countdown timer for the SETUP state
	 countdown_timer countdown_timer(
		  .clk(CLOCK_50),
		  .reset(reset),
		  .enable(wait_flag),
		  .timer_value(),
		  .end_reached(countdown_complete)
	 );
	 
    // Instantiate the Timer
    timer mole_timer (
        .clk(CLOCK_50),
        .reset(timer_reset | reset),
        .difficulty(0), // Set difficulty as needed
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
		  .new_mole(new_mole)
    );
	 
	seven_seg seg1(
		.bcd(edge_bcd),
		.segments(HEX7)
	);
	
	
	seven_seg seg2(
		.bcd(edge_detected),
		.segments(HEX5)
	);
	
	

    // Instantiate the Display
    display timer_display (
        .clk(CLOCK_50),
        .value(timer_value/*display_enable ? timer_value : 11'b0*/), // Show timer_value only in WAIT state
        .display0(HEX0),
        .display1(HEX1),
        .display2(HEX2),
        .display3(HEX3)
    );
    
    topRand mole_light (
        .clk(CLOCK_50),
        .reset(reset),
        .trigger(new_mole),
        .displayL(LEDR),
		  .position(mole_position)
    );
	 
//	 hammer hammer(
//		.clk(CLOCK_50),
//		.mole_position(mole_position),
//		.switch_states(SW),
//		.hit(HIT)
//	 );
	 
	 
 debounce_better_version uut (
  .pb_1(~KEY[2]), 
  .clk(CLOCK_50), 
  .pb_out(LEDG[3])
 );
 
 assign LEDG[5] = ~KEY[2];
	 
	 
	 
endmodule



module edge_det (
    input clk, signal,
    output edge_detected
    );   

	reg signal_d;
	reg signal_sync;
	always @(posedge clk)
		 begin
			  signal_d <= signal;
			  signal_sync <= signal_d;
		 end
	
	assign edge_detected = (signal_d & (!signal_sync));

		

endmodule  



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
    parameter MAX_MS = 5000,            // Maximum millisecond value
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

//module hammer (
//    input clk,
//    input [4:0] mole_position,  // Input: Position of the mole (0 to 17)
//    input [17:0] switch_states, // Input: Current states of the switches
//    output reg hit               // Output: 1 if the corresponding switch is toggled, 0 otherwise
//);
//
//	 wire edge_detected;
//	 
//	  double_edge_detector db(
//			.clk(clk),
//			.signal(switch_states[mole_position]),
//			.edge_detected(edge_detected)
//	  );
//	  
//    always @(*) begin
//        // Update previous switch state
//		  
//        // Check if switch at mole_position has toggled
//        if (edge_detected) begin
//            hit = 1'b1; // Switch has toggled
//        end else begin
//            hit = 1'b0; // Switch has not toggled
//        end
//
//    end
//
//endmodule

//fpga4student.com: FPGA projects, Verilog projects, VHDL projects
// Verilog code for button debouncing on FPGA
// debouncing module without creating another clock domain
// by using clock enable signal 
module debounce_better_version(input pb_1,clk,output pb_out);
wire slow_clk_en;
wire Q1,Q2,Q2_bar,Q0;
clock_enable u1(clk,slow_clk_en);
my_dff_en d0(clk,slow_clk_en,pb_1,Q0);

my_dff_en d1(clk,slow_clk_en,Q0,Q1);
my_dff_en d2(clk,slow_clk_en,Q1,Q2);
assign Q2_bar = ~Q2;
assign pb_out = Q1 & Q2_bar;
endmodule
// Slow clock enable for debouncing button 
module clock_enable(input Clk_100M,output slow_clk_en);
    reg [26:0]counter=0;
    always @(posedge Clk_100M)
    begin
       counter <= (counter>=249999)?0:counter+1;
    end
    assign slow_clk_en = (counter == 249999)?1'b1:1'b0;
endmodule
// D-flip-flop with clock enable signal for debouncing module 
module my_dff_en(input DFF_CLOCK, clock_enable,D, output reg Q=0);
    always @ (posedge DFF_CLOCK) begin
  if(clock_enable==1) 
           Q <= D;
    end
endmodule 

