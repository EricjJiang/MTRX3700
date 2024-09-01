module rng (
    input clk,
    input rst,
    output reg [4:0] out
);

    wire feedback;
    assign feedback = ~(out[4] ^ out[3]);

    reg [4:0] next;

    always @(posedge clk or posedge rst) begin
        if (rst)
            out <= 5'b0; // Reset output
        else
            out <= next; // Update output
    end

    always @(*) begin
        next <= {out[3:0], feedback}; // Shift and append feedback bit
    end

endmodule
