`timescale 1ns / 1ps

module countdown_timer_tb;

    // Parameters
    parameter MAX_MS = 3000;
    parameter CLKS_PER_MS = 50000;

    // Inputs
    reg clk;
    reg reset;
    reg enable;

    // Outputs
    wire [$clog2(MAX_MS)-1:0] timer_value;
    wire end_reached;

    // Instantiate Device Under Test:
    countdown_timer DUT (
        .MAX_MS(MAX_MS),
        .CLKS_PER_MS(CLKS_PER_MS)
    ) uut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .timer_value(timer_value),
        .end_reached(end_reached)
    );

    // Clock generation
    always #10 clk = ~clk;  // Generate a clock with a period of 20ns (50 MHz)

    initial begin
        $dumpfile("waveform.vcd");  // Tell the simulator to dump variables into the 'waveform.vcd' file during the simulation.
        $dumpvars();
        
        // Initialize Inputs
        clk = 0;
        reset = 1;
        enable = 0;

        // Apply reset
        #40;  
        reset = 0;
        #20;  

        // Enable countdown and observe decrement
        enable = 1;
        #60000000; 
        enable = 0;
        #100;

        // Apply reset during countdown
        enable = 1;
        #30000000; 
        reset = 1;
        #20;
        reset = 0;
        #1000000; 
        enable = 0;

        // Run until end_reached
        enable = 1;
        #150000000; 
        enable = 0;
        #100; 

        $finish();  // Finish the simulation.
    end

endmodule
