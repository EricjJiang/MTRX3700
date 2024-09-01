module display_tb;

    // Testbench signals
    logic clk;
    logic [$clog2(5000)-1:0] value;
    logic [6:0] display3, display2, display1, display0;

    // Instantiate the display module
    display DUT (
        .clk(clk),
        .value(value),
        .display3(display3),
        .display2(display2),
        .display1(display1),
        .display0(display0)
    );

    // Clock generation
    initial forever #1 clk = ~clk; // 1ns period clock

    // Testbench process
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars();

        // Initialize inputs
        clk = 0;
        value = 1438; // Example value

        // Wait for some time to let the module process the value
        #(2*50); // Adjust this as necessary to allow the FSM to process

        // Display the outputs
        $display("7Segs: %b, %b, %b, %b", display3, display2, display1, display0);

        // Finish simulation
        $finish();
    end

endmodule