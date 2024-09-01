module button_change_latch (
    input wire clk,               // Clock signal
    input wire rst_n,             // Asynchronous reset (active low)
    input wire button0,           // Push button 0
    input wire button1,           // Push button 1
    input wire button2,           // Push button 2
    output reg [3:0] difficulty   // Output difficulty level: 00=0, 01=1, 10=2
);

    // Registers to store the previous states of the buttons
    reg button0_d, button1_d, button2_d;

    // Always block to detect button state changes and set difficulty
    always @(posedge clk or posedge rst_n) begin
        if (rst_n) begin
            // Reset the latch and difficulty on reset
            button0_d <= 1'b0;
            button1_d <= 1'b0;
            button2_d <= 1'b0;
            difficulty <= 4'b0000;   // Default difficulty
        end else begin
            // Check for changes in each button and set difficulty
            if (button0 != button0_d) begin
                if (button0) begin
                    difficulty <= 4'b0000; // Set difficulty to 0
                end
            end
            if (button1 != button1_d) begin
                if (button1) begin
                    difficulty <= 4'b0001; // Set difficulty to 1
                end
            end
            if (button2 != button2_d) begin
                if (button2) begin
                    difficulty <= 4'b0010; // Set difficulty to 2
                end
            end

            // Update the previous button states
            button0_d <= button0;
            button1_d <= button1;
            button2_d <= button2;
        end
    end

endmodule
