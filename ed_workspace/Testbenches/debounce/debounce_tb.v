module debounce_tb;

  // Testbench signals
  reg clk;
  reg button;
  wire button_pressed;

  // Instantiate the synchroniser module
  synchroniser button_synchroniser (
    .clk(clk), 
    .x(button), 
    .y(button_sync)
  );

  // Instantiate the debounce module
  debounce #(.DELAY_COUNTS(2500)) uut (
    .clk(clk),
    .button(button_sync),  // Pass synchronized button signal to debounce module
    .button_pressed(button_pressed)
  );

  // Clock generation
  always #10 clk = ~clk; // 50 MHz clock (20 ns period)

  // Testbench process
  initial begin
    // Initialize inputs
    clk = 0;
    button = 0;

    // Test sequence
    #100 button = 1; // Press button
    #50 button = 0; // Release button
    #50050 button = 1; // Press button again
    #50050 button = 0; // Release button

    // Add more test cases as needed
    
    #1000 $stop; // Stop simulation
  end

  // Monitor changes for debugging
  initial begin
    $monitor("Time: %0t, Button: %b, Button_Sync: %b, Button_Pressed: %b", $time, button, button_sync, button_pressed);
  end

endmodule


