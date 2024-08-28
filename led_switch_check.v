module led_switch_checker (
    input wire clk,                 // Clock signal
    input wire reset,               // Reset signal
    input wire [17:0] leds,         // 18-bit input for LEDs
    input wire [17:0] switches,     // 18-bit input for switches
    output reg [3:0] score          // 4-bit score output
);

    // Score update logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            score <= 4'b0000; // Reset score to 0
        end 
        else begin
            for (int i = 0; i < 18; i++) begin
                if (leds[i] && switches[i]) begin
                    score <= score + 1; // Increment score if switch and corresponding LED are on
                end
            end
        end
    end

endmodule
