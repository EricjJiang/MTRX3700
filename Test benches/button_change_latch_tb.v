`timescale 1ns / 1ps

module button_change_latch_tb;

    // Inputs
    reg clk;
    reg rst_n;
    reg button0;
    reg button1;
    reg button2;

    // Outputs
    wire [3:0] difficulty;

    // Instantiate Device Under Test:
    button_change_latch DUT (
        .clk(clk),
        .rst_n(rst_n),
        .button0(button0),
        .button1(button1),
        .button2(button2),
        .difficulty(difficulty)
    );

    // Clock generation
    always #5 clk = ~clk;  // Generate a clock with a period of 10ns

    initial begin
        $dumpfile("waveform.vcd");  // Tell the simulator to dump variables into the 'waveform.vcd' file during the simulation.
        $dumpvars();

        // Initialize Inputs
        clk = 0;
        rst_n = 1;
        button0 = 0;
        button1 = 0;
        button2 = 0;

        // Apply reset
        rst_n = 0;
        #10;
        rst_n = 1;
        #10;

        // Test case 1: Press button0
        button0 = 1;
        #20;
        button0 = 0;
        #20;

        // Test case 2: Press button1
        button1 = 1;
        #20;
        button1 = 0;
        #20;

        // Test case 3: Press button2
        button2 = 1;
        #20;
        button2 = 0;
        #20;

        // Test case 4: Press multiple buttons in sequence
        button0 = 1;
        #20;
        button0 = 0;
        button1 = 1;
        #20;
        button1 = 0;
        button2 = 1;
        #20;
        button2 = 0;
        #20;

        // Test case 5: Reset
        rst_n = 0;
        #20;
        rst_n = 1;
        #20;

        $finish();  // Finish the simulation.
    end

endmodule
