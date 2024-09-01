This folder contains the subfodlers for each testbench.

Each subfolder contains the verilog or systemverilog for the module itself and any other modules it needs to run.
It also contains the verilog opr systemverilog testbench file for the module being tested.
Finally, each contains a unique shellscript simulate.sh for each testbench.

NOTE: The countdown_timer.v in Testbenches and FINAL are different, this is
because the CLKS_PER_MS was reduced to 50 in Testbenches (from 50000) so
the simulation in ed would not run out of memory.
