module debounce #(
  parameter DELAY_COUNTS = 2500 // 50us with clk period 20ns is 2500 counts
) (
    input clk, button,
    output reg button_pressed
);

  // Use a synchronizer to synchronize `button`.
  wire button_sync; // Output of the synchronizer. Input to your debounce logic.
  synchroniser button_synchroniser (.clk(clk), .x(button), .y(button_sync));

  reg [12:0] count; // 13-bit counter to count up to DELAY_COUNTS
  reg prev_button; // To hold the previous state of the button

  // Set the count flip-flop:
  always @(posedge clk) begin
      if (button_sync != prev_button) begin // If button isn't held up/down reset count
        count <= 0;
      end
      else if (count == DELAY_COUNTS) begin // Reset counter when it is full
        count <= 0;
      end
      else begin
        count <= count + 1; // Increment count as long as button is held and delay is insufficient
      end
  end

  // Set the prev_button flip-flop:
  always @(posedge clk) begin
    if (button_sync != prev_button) begin
      prev_button <= button_sync; // always set previous button to current press
    end
  end

  // Set the button_pressed flip-flop:
  always @(posedge clk) begin
    if (button_sync == prev_button && count == DELAY_COUNTS) begin // If button has been held for sufficient time
      button_pressed <= ~button_pressed; // Invert button_pressed status
    end
    else if (button_sync != prev_button && count == DELAY_COUNTS + 1) begin // If button has been off for sufficient time
      button_pressed <= ~button_pressed; 
    end
  end

endmodule



