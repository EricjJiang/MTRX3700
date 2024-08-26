`timescale 1ns/1ns /* This directive (`) specifies simulation <time unit>/<time precision>. */

module timer_tb;

    reg         clk, reset, enable;   // Need to use `reg` here (set in always block).
	 reg	[1:0]	 difficulty;
    reg  [11:0] end_value;
    wire [11:0] timer_value;
	 wire			 end_reached;

    timer DUT (
        .clk(clk), .reset(reset), .difficulty(difficulty), .end_value(end_value), .enable(enable),
        .timer_value(timer_value)
    );

    initial begin : clock_block
        clk = 1'b0;
        forever begin
            #10;
            clk = ~clk; // Clock period = 20 ns (half-period is 10 ns)
        end
    end

    initial begin  // Run the following code starting from the beginning of the simulation.
        $dumpfile("waveform.vcd");  // Tell the simulator to dump variables into the 'waveform.vcd' file during the simulation.
        $dumpvars();
        /* NOTE: that since we have large delays in this simulation, it is possible for the waveform.vcd file
         *       to get too large for this workspace. If you get file space errors, minimise the delays in this
         *       testbench and delete the waveform file each time before running.
         *       Note to fix this, the .fst file format could be used. This is an alternate waveform format that includes compression. */

        #(500000);         // Wait 500 us (500000 ns) before enabling the timer.

        enable = 1'b1;     // Enable the timer module.

        /** Test counting up to 100ms on easy **/
        difficulty = 0;		  // Set difficulty to lowest
        reset  = 1'b1;		  // Reset counter to count upwards (as up = 1'b1).
		  end_value = 100;     // Set timer to end at 100ms
			
        #20;               // Wait 1 clock period to *clock* new values before deasserting `reset` (i.e. a reset pulse).
        reset  = 1'b0;     // Disable reset to start counting:

        #20;               // Wait a clock period to get the new timer_value value after deasserting `reset`.
        
        // Print out the timer value over the next 100 milliseconds:
        repeat(110) begin
            $display("t=%0d ns: timer_value=%0d", $time, timer_value);  // $time gets current simulation time.
            #1000000; // Wait 1 millisecond (1000000 ns)
        end
        if (end_reached == 1) $warning("Timer reached its end at timer_value=%0d.",timer_value);

        #500000; // Wait 0.5 milliseconds (500000 ns)
		  difficulty = 1; 	 // Set difficulty to medium
		  reset = 1'b1;
		  end_value = 100;    // Medium difficulty will reach 100ms in 50ms
		  
		  #20;
		  reset = 1'b0;
		  
		  #20;
		  
		  repeat(100) begin
            $display("t=%0d ns: timer_value=%0d", $time, timer_value);  // $time gets current simulation time.
            #1000000; // Wait 1 millisecond (1000000 ns)
        end
        if (end_reached == 1) $warning("Timer reached its end at timer_value=%0d.",timer_value);
		  
		  #500000; // Wait 0.5 milliseconds (500000 ns)
		  difficulty = 2; 	 // Set difficulty to hard
		  reset = 1'b1;
		  end_value = 100;	 // Hard difficulty will reach 100ms in ~33ms
		  
		  #20;
		  reset = 1'b0;
		  
		  #20;
		  
		  repeat(100) begin
            $display("t=%0d ns: timer_value=%0d", $time, timer_value);  // $time gets current simulation time.
            #1000000; // Wait 1 millisecond (1000000 ns)
        end
        if (end_reached == 1) $warning("Timer reached its end at timer_value=%0d.",timer_value);
		  #500000; // Wait 0.5 milliseconds (500000 ns)

        $finish();  // Finish the simulation.
    end 
    
endmodule
