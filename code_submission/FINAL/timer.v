module timer #(
    parameter MAX_MS = 5000,            // Maximum millisecond value
    parameter CLKS_PER_MS = 50000       // Number of clock cycles in a millisecond?
) (
    input                               clk,
    input                               reset,          // Reset timer_value, count, and end_reached to 0
    input  [3:0]                        difficulty,     // Increase timer at 100%, 200%, or 300% speed
    input  [$clog2(MAX_MS)-1:0]         end_value,      // The value at which the end_reached flag is changed
    input                               enable,         // Toggle timer on/off
    output reg                          end_reached,
    output reg [$clog2(MAX_MS)-1:0]     timer_value
);



    reg [$clog2(CLKS_PER_MS)-1:0] count;

    always @(posedge clk) begin
        // If reset is high, set clock and counters to 0
        if (reset) begin    
            count <= 0;
            timer_value <= 0;
            end_reached <= 0;
        end
        // If timer is enabled, start counting
        else if (enable) begin
            // If the clock has counted one ms
            if (count == CLKS_PER_MS - 1) begin
                // Set clock counter back to 0
                count <= 0;

                // Check if the end value has been reached
                if (timer_value >= end_value) begin
                    end_reached <= 1;     // Set end_reached signal high
                    timer_value <= 0;     // Reset timer value immediately
                end else begin
                    // Increment timer value based on difficulty
                    case (difficulty)
                        2: timer_value <= timer_value + 3;  // Hard difficulty
                        1: timer_value <= timer_value + 2;  // Medium difficulty
                        0: timer_value <= timer_value + 1;  // Easy difficulty
                        default: timer_value <= timer_value + 1;
                    endcase

                    end_reached <= 0;  // Ensure end_reached is low if not reached
                end
            end
            else begin
                count <= count + 1;  // Increment clock counter
            end
        end
    end
endmodule
