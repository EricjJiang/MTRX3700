module hammer_tb;

    // Inputs
    reg clk;
    reg reset;
    reg [17:0] switches;
    reg [4:0] mole_position;

    // Outputs
    wire hit;
    wire [11:0] hit_count;

    // Instantiate the Unit Under Test (UUT)
    hammer uut (
        .clk(clk),
        .reset(reset),
        .switches(switches),
        .mole_position(mole_position),
        .hit(hit),
        .hit_count(hit_count)
    );

    // Clock generation
    always #5 clk = ~clk;  // Generate a clock with a period of 10ns

    initial begin
        $dumpfile("hammer_waveform.vcd");  // Tell the simulator to dump variables into the 'hammer_waveform.vcd' file during the simulation.
        $dumpvars();

        // Initialize Inputs
        clk = 0;
        reset = 1;
        switches = 18'b0;
        mole_position = 5'b0;

        #10;
        reset = 0;

        // Hit the mole at position 0
        mole_position = 5'b00000;  // Mole appears at position 0
        switches[0] = 1;  // Switch 0 is pressed
        #10;
        $display("Position 0: switches=%b, mole_position=%d, hit=%b, hit_count=%d", 
                  switches, mole_position, hit, hit_count);
        switches[0] = 0;
        #10;

        // Miss the mole (no switch pressed)
        mole_position = 5'b00001;  // Mole appears at position 1
        #10;
        $display("Miss: switches=%b, mole_position=%d, hit=%b, hit_count=%d", 
                  switches, mole_position, hit, hit_count);
        #10;

        // Hit the mole at a different position
        mole_position = 5'b00010;  // Mole appears at position 2
        switches[2] = 1;  // Switch 2 is pressed
        #10;
        $display("Position 2: switches=%b, mole_position=%d, hit=%b, hit_count=%d", 
                  switches, mole_position, hit, hit_count);
        switches[2] = 0;
        #10;

        // Reset during a hit
        mole_position = 5'b00011;  // Mole appears at position 3
        switches[3] = 1;  // Switch 3 is pressed
        #10;
        $display("Before Reset: switches=%b, mole_position=%d, hit=%b, hit_count=%d", 
                  switches, mole_position, hit, hit_count);
        reset = 1;
        #10;
        reset = 0;
        #10;
        $display("After Reset: switches=%b, mole_position=%d, hit=%b, hit_count=%d", 
                  switches, mole_position, hit, hit_count);
        switches[3] = 0;
        #10;

        // Hit the mole multiple times at different positions
        mole_position = 5'b00100;  // Mole appears at position 4
        switches[4] = 1;
        #10;
        $display("Position 4 First Hit: switches=%b, mole_position=%d, hit=%b, hit_count=%d", 
                  switches, mole_position, hit, hit_count);
        switches[4] = 0;
        #10;

        switches[4] = 1;  // Hit again at position 4
        #10;
        $display("Position 4 Second Hit: switches=%b, mole_position=%d, hit=%b, hit_count=%d", 
                  switches, mole_position, hit, hit_count);
        switches[4] = 0;
        #10;

        $finish();  // Finish the simulation.
    end

endmodule
