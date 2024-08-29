module debounce_tb;
    // Testbench Signals
    reg clk;
    reg button;
    wire button_pressed;

    // Instantiate the debounce module
    debounce dut (
        .clk(clk),
        .button(button),
        .button_pressed(button_pressed)
    );

    // Clock generation: 20ns clock period (50 MHz)
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end
		
	 assign	button_pressed = 0;
    // Test procedure
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars();
        // Initialize signals
        button = 0;

        // Apply the first button press (bouncing scenario)
        #100 button = 1;
        #50  button = 0;  // Bouncing to 0 quickly
        #50  button = 1;  // Button settles to 1
        #50;
        $display("button_pressed: %b", button_pressed);

        //TODO:
        // Wait enough time for debounce to trigger
        // Apply the button release (another bouncing scenario)
        // Wait enough time for debounce to trigger

        $finish(); // End simulation
    end

endmodule
