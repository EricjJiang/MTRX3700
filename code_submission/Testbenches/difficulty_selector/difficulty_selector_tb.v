module difficulty_selector_tb;

    // Inputs as regs (since they are driven in the initial block)
    reg KEY0_debounced; // Hard
    reg KEY1_debounced; // Medium
    reg KEY2_debounced; // Easy

    // Outputs as wires
    wire [3:0] difficulty;

    // Instantiate Device Under Test:
    difficulty_selector DUT (
        .clk(),  
        .KEY0_debounced(KEY0_debounced),
        .KEY1_debounced(KEY1_debounced),
        .KEY2_debounced(KEY2_debounced),
        .difficulty(difficulty)
    );

    initial begin
        $dumpfile("waveform.vcd");  // Tell the simulator to dump variables into the 'waveform.vcd' file during the simulation.
        $dumpvars();
        
        repeat(5) begin
            // Test different combinations of button presses:
            
            // Press Easy (KEY2)
            KEY0_debounced = 0;
            KEY1_debounced = 0;
            KEY2_debounced = 1;
            #10; 
            $display("Easy: KEY0=%b, KEY1=%b, KEY2=%b, difficulty=%04b", 
                      KEY0_debounced, KEY1_debounced, KEY2_debounced, difficulty);
            
            // Press Medium (KEY1)
            KEY0_debounced = 0;
            KEY1_debounced = 1;
            KEY2_debounced = 0;
            #10;
            $display("Medium: KEY0=%b, KEY1=%b, KEY2=%b, difficulty=%04b", 
                      KEY0_debounced, KEY1_debounced, KEY2_debounced, difficulty);
            
            // Press Hard (KEY0)
            KEY0_debounced = 1;
            KEY1_debounced = 0;
            KEY2_debounced = 0;
            #10;
            $display("Hard: KEY0=%b, KEY1=%b, KEY2=%b, difficulty=%04b", 
                      KEY0_debounced, KEY1_debounced, KEY2_debounced, difficulty);
            
            // No button pressed
            KEY0_debounced = 0;
            KEY1_debounced = 0;
            KEY2_debounced = 0;
            #10;
            $display("None: KEY0=%b, KEY1=%b, KEY2=%b, difficulty=%04b", 
                      KEY0_debounced, KEY1_debounced, KEY2_debounced, difficulty);

            // All buttons pressed simultaneously
            KEY0_debounced = 1;
            KEY1_debounced = 1;
            KEY2_debounced = 1;
            #10;
            $display("All: KEY0=%b, KEY1=%b, KEY2=%b, difficulty=%04b", 
                      KEY0_debounced, KEY1_debounced, KEY2_debounced, difficulty);
        end

        $finish();  // Finish the simulation.
    end

endmodule
