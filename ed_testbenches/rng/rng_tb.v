module rng_tb;

    // Testbench signals
    logic clk;
    logic rst;
    logic [4:0] out;

    // Instantiate the DUT (Design Under Test)
    rng dut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk;  // 50MHz clock (20ns period)
    end

    // Test sequence
    initial begin
    $dumpfile("waveform.vcd");  // Tell the simulator to dump variables into the 'waveform.vcd' file during the simulation.
    $dumpvars();
        // Initialize signals
        rst = 1;
        #20;
        rst = 0;

        // Observe the output for several clock cycles
        $display("Starting RNG test...");
        repeat (20) begin
            #20;
            $display("Time = %0t: RNG Output = %b", $time, out);
        end

        // Reset the RNG and check the output
        rst = 1;
        #20;
        rst = 0;
        $display("After reset: RNG Output = %b", out);
        
        // Observe the output again for several clock cycles after reset
        repeat (10) begin
            #20;
            $display("Time = %0t: RNG Output = %b", $time, out);
        end

        // Test completed
        $display("RNG test completed.");
        $finish;
    end

endmodule

