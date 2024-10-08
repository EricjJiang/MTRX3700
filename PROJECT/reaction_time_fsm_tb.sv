//module reaction_time_fsm_tb;
//    // Step 1: Define test bench variables:
//    logic        clk;
//    logic        button_pressed;
//    logic [10:0] timer_value;
//    logic        reset;
//    logic        up;
//    logic        enable;
//    logic        led_on;
//
//    logic [10:0] start_value = 10; // Initialise to 10.
//
//    // Step 2: Instantiate Device Under Test:
//    reaction_time_fsm DUT (.*);             // SystemVerilog feature: `.*` automatically connects ports of the instantiated module to variables in this module with the same port/variable name!! So useful :D.
//    timer #(.CLKS_PER_MS(2)) timer_u0 (.*); // Upload your working timer code from Lesson 1.
//    //         ^^^ Set CLKS_PER_MS to 2 for testing purposes, so we don't generate large waveform files.
//
//    // Step 3: Toggle the clock variable every 10 time units to create a clock signal **with period = 20 time units**:
//    localparam CLK_PERIOD = 20;
//    initial forever #(CLK_PERIOD/2) clk = ~clk; // forever is an infinite loop!
//
//    // Step 4: Initial block with initial inputs. To specify later inputs, use the delay operator `#`.
//    initial begin
//        $dumpfile("waveform.vcd");  // Tell the simulator to dump variables into the 'waveform.vcd' file during the simulation. Required to produce a waveform .vcd file.
//        $dumpvars();
//        clk = 0; // Make sure clock has an initial value.
//        
//        start_value = 10;
//        button_pressed = 0;
//        #(CLK_PERIOD*10);   // 10 Clock cycle delay.
//        button_pressed = 1; // Start count down
//        #(CLK_PERIOD*10);   // Timer counts 5 times from 10 to 5 (1 count every 2 clock cycles).
//        button_pressed = 0;
//        #(CLK_PERIOD*40);   // Timer counts 19 times (not 20, as it takes a clock cycle to reset the timer!)
//                            // So, the timer should have counted from 5 to 0, then up to 14.
//        button_pressed = 1; // React!
//        #(CLK_PERIOD*10);   // Timer should have paused (enable=0).
//        button_pressed = 0;
//        #(CLK_PERIOD*100);  // Pause for a further 100 cycles.
//        button_pressed = 1; // Go back to initial state.
//        #(CLK_PERIOD*10);
//        $display(" reset: %b, up: %b, enable: %b, led_on: %b", reset, up, enable, led_on);
//
//        $finish(); // Important: must end simulation (or it will go on forever!)
//    end
//endmodule
