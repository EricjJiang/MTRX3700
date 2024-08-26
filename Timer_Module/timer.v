`timescale 1ns/1ns /* This directive (`) specifies simulation <time unit>/<time precision>. */

module timer #(
    parameter MAX_MS = 4095,            // Maximum millisecond value
    parameter CLKS_PER_MS = 50000		 // Number of clock cycles in a millisecond?
) (
    input                       clk,
    input                       reset,		  // Reset timer_value, count, and end_reached to 0
    input  [1:0]                difficulty, // Increase timer at 100%, 200%, or 300% speed
    input  [$clog2(MAX_MS)-1:0] end_value,  // The value at which the end_reached flag is changed
    input                       enable,	  // Toggle timer on/off
    output reg [$clog2(MAX_MS)-1:0] timer_value,
	 output reg						  end_reached
);

    reg [$clog2(CLKS_PER_MS)-1:0] count;
    reg count_fast;

    
    always @(posedge clk)
    begin
        // If reset is high set clock to 0
        if (reset) 
        begin    
            count <= 0;
				timer_value <= 0;
				end_reached <= 0;
        end
    // If timer is enabled then start counting
        else if (enable) 
        begin
            // If the clock has counted one ms
            if(count == CLKS_PER_MS - 1) 
            begin
                // Set clock counter back to 0
                count <= 0;
					 
					 // Raise end_reached flag when end value is reached
					 if (timer_value >= end_value) begin
						 end_reached <= 1;
					 end
                
					 // If on hard difficulty count at max speed
                else if(difficulty == 2) 
                begin
                    timer_value <= timer_value + 3;
                end
                
					 // If on medium difficulty count at moderate speed
                else if(difficulty == 1)
                begin
                    timer_value <= timer_value + 2;
                end
					 
					 // If on easy difficulty count at minimum speed
					 else if(difficulty == 0)
                begin
                    timer_value <= timer_value + 1;
                end
            end
            // If timer is disabled, increment clock
            else 
            begin
                count <= count + 1;
            end
        end
    end

endmodule


