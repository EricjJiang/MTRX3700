`timescale 1ns / 1ps

module countdown_timer_tb;
    // Define test bench variables and clock
    reg clk;        
    reg reset;  
    reg enable;
    wire [$clog2(MAX_MS)-1:0] timer_value; 
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
    initial forever #10 clk = ~clk; 

    // Initial block to specify input values starting from time = 0. 
    initial begin  
        $dumpfile("waveform.vcd");  // Tell the simulator to dump variables into the 'waveform.vcd' file during the simulation. Required to produce a waveform .vcd file.
        $dumpvars();                // Also required to tell simulator to dump variables into a waveform (with filename specified above).

        // Initialize inputs
        clk = 0;
        reset = 1; 
        enable = 0; 

        // Deassert reset and enable the timer
        #20;
        reset = 0;  
        enable = 1;

        // Run the timer for a few cycles and then reset
        repeat(5) begin
            #100000; 
            $display("Time: %0t | Timer Value: %0d | End Reached: %b", $time, timer_value, end_reached);
        end

        // Assert reset during operation
        #20;
        reset = 1;  
        #20;
        reset = 0;  

        // Continue running the timer
        repeat(5) begin
            #100000; 
            $display("Time: %0t | Timer Value: %0d | End Reached: %b", $time, timer_value, end_reached);
        end

        $finish(); 
    end
endmodule
