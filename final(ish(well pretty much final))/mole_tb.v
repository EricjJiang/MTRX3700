module mole_tb;

    // Test bench signals
    reg  [4:0] number;
    wire [17:0] displayL;

    mole DUT(
        .number(number),
        .displayL(displayL)
    );

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars();

        // Initialize inputs
        number = 16; // Example value

        // Wait for some time to let the module process the value
        #(2*50); // Adjust this as necessary to allow the FSM to process

        // Display the outputs
        $display("DisplayL: %b", displayL);

        // Finish simulation
        $finish();
    end

endmodule
