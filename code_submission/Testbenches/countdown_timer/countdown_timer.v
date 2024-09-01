module countdown_timer #(
    parameter MAX_MS = 3000,            // Maximum millisecond value
    parameter CLKS_PER_MS = 50      //CLKS_PER_MS should be 50000 changed to 50 for simulation // Number of clock cycles in a millisecond
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
