module top (
input	[3:0]		KEY,
input				CLOCK_50,
output [17:0]	LEDR
);


synchroniser u0(
	.clk(CLOCK_50),
	.x(~KEY[0]),
	.y(button_sync)
);

debounce u1(
	.clk(CLOCK_50),
	.button(button_sync),
	.button_pressed(LEDR[17:0])
);


endmodule