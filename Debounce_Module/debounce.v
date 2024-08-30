module debounce #(
  parameter DELAY_COUNTS = 2500
) (
  input clk, button,
  output reg button_pressed
);

  // Use a synchronizer to synchronize `button`.
  wire button_sync;
  synchroniser button_synchroniser (
    .clk(clk),
    .x(button),
    .y(button_sync)
  );

  // Declare and initialize registers
  reg [11:0] count = 0;
  reg prev_button = 0;

  // Set the count flip-flop
  always @(posedge clk) begin
    if (button_sync != prev_button) begin
      count <= 0;
    end else if (count == DELAY_COUNTS) begin
      count <= count; // Hold the count value
    end else begin
      count <= count + 1;
    end
  end

  // Set the prev_button flip-flop
  always @(posedge clk) begin
    if (button_sync != prev_button) begin
      prev_button <= button_sync;
    end else begin
      prev_button <= prev_button;
    end
  end

  // Set the button_pressed flip-flop
  always @(posedge clk) begin
    if (button_sync == prev_button && count == DELAY_COUNTS) begin
      button_pressed <= prev_button;
    end else begin
      button_pressed <= button_pressed; // Hold the previous state
    end
  end

endmodule



