module reaction_time_fsm_tb;

    // Testbench signals
    logic clk;
    logic play;
    logic countdown_complete;
    logic mole_complete;
    logic [11:0] score;
    logic reset;
    logic wait_flag;
    logic play_flag;
    logic new_mole;
    logic gameover_flag;

    // Instantiate the DUT (Design Under Test)
    reaction_time_fsm #(
        .MAX_MS(5000)
    ) dut (
        .clk(clk),
        .play(play),
        .countdown_complete(countdown_complete),
        .mole_complete(mole_complete),
        .score(score),
        .reset(reset),
        .wait_flag(wait_flag),
        .play_flag(play_flag),
        .new_mole(new_mole),
        .gameover_flag(gameover_flag)
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
        play = 0;
        countdown_complete = 0;
        mole_complete = 0;
        score = 12'd0;

        // Test 1: Start in SETUP, then transition to WAIT
        #20;  // Wait for 20ns
        play = 1;
        #20;  // Wait for 20ns
        play = 0;
        assert(dut.current_level == dut.WAIT) else $fatal("Test 1 Failed: Did not transition to WAIT state");

        // Test 2: Transition from WAIT to PLAY after countdown
        #20;
        countdown_complete = 1;
        #20;
        countdown_complete = 0;
        assert(dut.current_level == dut.PLAY) else $fatal("Test 2 Failed: Did not transition to PLAY state");

        // Test 3: Display new mole and stay in PLAY
        mole_complete = 1;
        #20;
        mole_complete = 0;
        assert(new_mole == 1) else $fatal("Test 3 Failed: New mole signal not triggered");

        // Test 4: Transition from PLAY to GAME_OVER when score reaches 1000
        score = 12'd1000;
        #20;
        assert(dut.current_level == dut.GAME_OVER) else $fatal("Test 4 Failed: Did not transition to GAME_OVER state");

        // Test 5: Check reset state after GAME_OVER
        #20;
        assert(reset == 0 && gameover_flag == 1) else $fatal("Test 5 Failed: GAME_OVER state not set correctly");

        // Test completed
        $display("All tests passed successfully.");
        $finish;
    end

endmodule

