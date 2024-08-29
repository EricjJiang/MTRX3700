module led_switch_check (
    input wire clk,                 // Clock signal
    input wire reset,               // Reset signal
    input wire [17:0] leds,         // 18-bit input for LEDs
    input wire [17:0] switches,     // 18-bit input for switches
    output reg [3:0] score          // 4-bit score output
);


	 // Sequential : Create flip-flop to store state variable:
    always @(posedge clk) begin
        if (reset) begin
            score <= 4'b0000; //reset score to 0
			end
			else if (switches[3] ~^ leds[3]) begin 
					score <= score + 1; 
			end
	 end
  
endmodule
