module count_score (
    input [17:0] SW,           // 18 switches
    input [17:0] mole_on,      // 18 signals indicating whether a corresponding mole is on
    input clk,                 // Clock signal
    input rst,                 // Reset signal
    output reg [4:0] score,    // Score (max 20)
    output reg [1:0] miss,     // Miss count (max 3)
    output reg end_game        // End game signal
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            score <= 0;
            miss <= 0;
            end_game <= 0;
        end 
        
        else if (!end_game) begin
            integer i;
            for (i = 0; i < 18; i = i + 1) begin
                if (SW[i] == 1) begin
                    if (mole_on[i] == 1) begin
                        score <= score + 1;
                    end else begin
                        miss <= miss + 1;
                    end
                end
            end

            // Check end game conditions
            if (score >= 20 || miss >= 3) begin
                end_game <= 1;
            end
        end
    end

endmodule
