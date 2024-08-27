module reaction_time_fsm #(
    parameter MAX_MS=2047    
)(
    input                             clk,
    input                             button_pressed,
    input        [$clog2(MAX_MS)-1:0] timer_value,
    output logic                      reset,
    output logic                      enable_Easy,
    output logic                      enable_Hard,
    output logic                      enable_Hell,
    output logic                      score,
    output logic                      led_on
);

    // Edge detection block here!
    logic button_q0, button_edge;
    always_ff @(posedge clk) begin : edge_detect
        button_q0 <= button_pressed;
    end : edge_detect

    assign button_edge = (button_pressed > button_q0);

    // State typedef enum here! (See 3.1 code snippets)
    typedef enum logic [1:0] {Easy, Hard, Hell} state_type;
    state_type current_level = Easy, next_level;

    typedef enum logic [1:0] {On, Off} mole_state;
    typedef enum logic [1:0] {High, Low} switch;

    always_comb begin
        case (switch) // switches for the moles
            //when the state of a switch changes, if the mole is on, add 5 points, if not minus 2
            High: begin
                case (mole_state)
                    On: score <= score + 5;
                    Off: score <= score - 2;
                endcase 
            end
            Low: begin
                case (mole_state)
                    On: score <= score + 5;
                    Off: score <= (score <= 2) ? score - 2 : 0;
                endcase
            end
        endcase
    end

    // always_comb for next_state_logic here! (See 3.1 code snippets)
    always_comb begin
        next_level = current_level; // Default Value for next_state
        case (current_level)
            Easy: begin
                next_level = (button_edge) ? Hard : Easy;  // Use enum for state variable.
            end
            Hard: begin
                next_level = (button_edge) ? Hell : Hard;
            end
            Hell: begin
                next_level = (button_edge) ? Easy : Hell;
            end
        endcase
    end

    // always_ff for FSM state variable flip-flops here! (See 3.1 code snippets)
    always_ff @(posedge clk) begin
        current_level <= next_level;
    end
    
    always_comb begin : double_dabble_fsm_output // to timer
        case (current_level)
    // Continuously assign outputs here! (See 3.1 code snippets)
            Easy: begin
                reset = 1;
                enable_Easy = 1;
                enable_Hard = 0;
                enable_Hell = 0;
                led_on = 0;
            end
            Hard: begin
                reset = 1;
                enable_Easy = 0;
                enable_Hard = 1;
                enable_Hell = 0;
                led_on = 0;
            end
            Hell: begin
                reset = 1;
                enable_Easy = 0;
                enable_Hard = 0;
                enable_Hell = 1;
                led_on = 0;
            end
        endcase
    end
endmodule
