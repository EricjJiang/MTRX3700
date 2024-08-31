module debounce #(
  parameter DELAY_COUNTS = 2500/*FILL-IN*/ // 50us with clk period 20ns is ____ counts
) (
    input clk, button,
    output reg button_pressed
);

  // Use a synchronizer to synchronize `button`.
  wire button_sync; // Output of the synchronizer. Input to your debounce logic.
  synchroniser button_synchroniser (.clk(clk), .x(button), .y(button_sync));

  // Note: Use the synchronized `button_sync` wire as the input signal to the debounce logic.
  // Declare the necessary registers
  reg [11:0] count; // 12 bits can store values up to 4095, which is enough for 2500 counts.
  reg prev_button;

  /*** Fill in the following scaffold: ***/

  // Set the count flip-flop:
  always @(posedge clk) begin
      if (button_sync != prev_button) begin
        count <= 0/* FILL-IN */;
      end
      else if (count == DELAY_COUNTS) begin
        count <= count/* FILL-IN */;
      end
      else begin
        count <= count + 1/* FILL-IN */;
      end
  end

  // Set the prev_button flip-flop:
  always @(posedge clk) begin
    if (button_sync != prev_button) begin
      prev_button <= button_sync/* FILL-IN */;
    end
    else begin
      prev_button <= prev_button/* FILL-IN */;
    end
  end

  // Set the button_pressed flip-flop:
  always @(posedge clk) begin
    if (button_sync == prev_button && count == DELAY_COUNTS) begin
      button_pressed <= prev_button/* FILL-IN */;
    end
    else begin
      button_pressed <= button_pressed/* FILL-IN */;
    end
  end

endmodule


