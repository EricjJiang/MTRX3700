module reaction_time_fsm #(
    parameter MAX_MS = 4095    
)(
    input                             clk,
    input        [$clog2(MAX_MS)-1:0] timer_value,
    input                             play,
    output logic                      reset,
    output logic                      countdown, // Signal to enable the timer countdown
    output logic                      display_enable,
    output logic                      led_on
);

    typedef enum logic [1:0] {SETUP, WAIT, PLAY, RESTART} state_type;
    state_type current_level = SETUP, next_level;

	
    always_comb begin
        next_level = current_level; // Default Value for next_state
        case (current_level)
            SETUP: begin
                next_level = play ? WAIT : SETUP;  // Use enum for state variable.
            end
            WAIT: begin
                next_level = (timer_value == 2000) ? PLAY : WAIT;
            end
            PLAY: begin
                next_level = play ? RESTART : PLAY;
            end
            RESTART: begin
                next_level = WAIT;
            end
        endcase
    end

    always_ff @(posedge clk) begin
        current_level <= next_level;
    end
    
    always_comb begin
        case (current_level)
            SETUP: begin
                countdown = 1'b0;           
                reset = 1'b1;
                display_enable = 1'b0;
                led_on = 1'b0;
            end
            WAIT: begin
                countdown = 1'b1;           
                reset = 1'b0;
                display_enable = 1'b1;
                led_on = 1'b0;
            end
            PLAY: begin
                countdown = 1'b0;           
                reset = 1'b0;
                display_enable = 1'b0;
                led_on = 1'b1;
            end
            RESTART: begin
                countdown = 1'b0;           
                reset = 1'b0;
                display_enable = 1'b0;
                led_on = 1'b0;
            end
        endcase
    end

endmodule
