module hammer (
    input clk,
    input reset,
    input [17:0] switches,  // Assume switches[0] corresponds to mole position 0, etc.
    input [4:0] mole_position,  // Current mole position
    output reg hit,  // Signal to indicate that the mole was hit
	 output reg [11:0] hit_count
);
    reg [17:0] prev_switches;  // Register to store the previous state of the switches

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            prev_switches <= 18'b0;
            hit <= 1'b0;
				hit_count <= 0;
        end else begin
            // Detect if the switch corresponding to the mole position has changed state
            if (switches[mole_position] != prev_switches[mole_position]) begin
                hit <= 1'b1;
					 hit_count <= hit_count + 50;
            end else begin
                hit <= 1'b0;
            end
            // Update the previous switches state
            prev_switches <= switches;
        end
    end
endmodule
