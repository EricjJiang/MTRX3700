`timescale 1ns / 1ns

module countdown_timer_tb;
    // Define test bench variables and clock
    reg clk;        
    reg reset;  
    reg enable;
    wire [11:0] timer_value; 
    wire end_reached; 

    // Instantiate Device Under Test (DUT):
    countdown_timer DUT ( 
        .clk(clk), 
        .reset(reset), 
        .enable(enable), 
        .timer_value(timer_value), 
        .end_reached(end_reached) 
    );
   

    // Toggle the clock variable every 10 time units to create a clock signal **with period = 20 time units**:
    initial begin : clock_block
		clk = 1'b0;
		forever begin
			#10;
			clk = ~clk;
		end
	end

    // Initial block to specify input values starting from time = 0. 
    initial begin  
        $dumpfile("waveform.vcd");  // Tell the simulator to dump variables into the 'waveform.vcd' file during the simulation. Required to produce a waveform .vcd file.
        $dumpvars();                // Also required to tell simulator to dump variables into a waveform (with filename specified above).

			// Initialize signals
        enable = 1'b0;
        reset = 1'b0;
			
			#(500000) // Wait 500 us before enabling timer
			
			
			reset = 1'b1;
			
			#40;
			reset = 1'b0;
			
			enable = 1'b1;

        // Run the timer for a few cycles and then reset
        repeat(10) begin
            #300000; 
            $display("Time: %0t | Timer Value: %0d | End Reached: %b", $time, timer_value, end_reached);
        end

        // Assert reset during operation
        #20;
        reset = 1;  
        #40;
        reset = 0;  

        // Continue running the timer
        repeat(10) begin
            #300000; 
            $display("Time: %0t | Timer Value: %0d | End Reached: %b", $time, timer_value, end_reached);
        end
		  
		  
		  repeat(10) begin
            #300000; 
            $display("Time: %0t | Timer Value: %0d | End Reached: %b", $time, timer_value, end_reached);
        end

        $finish(); 
    end
	 
endmodule
