module top (
input [17:0]	SW,
input	[3:0]		KEY,
input				CLOCK_50,
output [17:0]	LEDR
);

timer u0(
	.clk(CLOCK_50),
	.reset(~KEY[0]),
	.difficulty(SW[15:14]),
	.end_value(SW[11:0]),
	.enable(SW[17]),
	.timer_value(LEDR[11:0]),
	.end_reached(LEDR[12])
);

endmodule