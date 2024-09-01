module reaction_time_fsm #(
    parameter MAX_MS = 5000    
)(
    input                             clk,
    input                             play,
	 input									  countdown_complete,
	 input									  mole_complete,
	 input [11:0]							  score,
    output logic                      reset,
	 output logic 							  wait_flag,
	 output logic 							  play_flag,
	 output logic							  new_mole,
	 output logic							  gameover_flag
);

    typedef enum logic [2:0] {SETUP, WAIT, PLAY, GAME_OVER} state_type;
    state_type current_level = SETUP, next_level;

    logic toggle_timer_signal, toggle_timer_prev; // Register to hold previous state of toggle_timer

	 
    always_ff @(posedge clk) begin
		  current_level <= next_level;
        // Handle state-specific sequential logic
        if (current_level == PLAY && mole_complete) begin
            new_mole <= 1;
        end else begin
            new_mole <= 0;
        end
    end	 

	 
    always_comb begin
        next_level = current_level; // Default Value for next_state
        case (current_level)
            
				SETUP: begin
                next_level = play ? WAIT : SETUP;
            end
            
				WAIT: begin
                next_level = (countdown_complete) ? PLAY : WAIT;
            end
            
				PLAY: begin
					 next_level = (score == 1000) ? GAME_OVER : PLAY;
            end
				
				GAME_OVER: begin
					 next_level = GAME_OVER;
				end
				
        endcase
    end

    always_comb begin

        case (current_level)
            SETUP: begin
                reset = 1'b1;
					 wait_flag = 1'b0;
					 play_flag = 1'b0;
					 gameover_flag = 1'b0;
            end
            WAIT: begin
                reset = 1'b0;
					 wait_flag = 1'b1;
					 play_flag = 1'b0;
					 gameover_flag = 1'b0;
            end
            PLAY: begin
                reset = 1'b0; // Reset timer before displaying mole
					 wait_flag = 1'b0;
					 play_flag = 1'b1;
					 gameover_flag = 1'b0;
            end
				
            GAME_OVER: begin
                reset = 1'b0;
					 wait_flag = 1'b0;
					 play_flag = 1'b0;
					 gameover_flag = 1'b1;
				end
				
        endcase
    end
	 
endmodule
