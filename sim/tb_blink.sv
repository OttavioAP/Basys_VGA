`timescale 1ns/1ps

module tb_blink;

    logic clk = 0;
    logic reset = 1;
    logic led;

    // 100 MHz clock = 10 ns period
    always #5 clk = ~clk;

    blink dut (
        .clk(clk),
        .reset(reset),
        .led(led)
    );

    initial begin
        $dumpfile("sim/build/blink.vcd");
	$dumpvars(1, tb_blink.dut);

        #100;
        reset = 0;

        // Run long enough to see a toggle
        repeat (50) @(posedge clk);

        $finish;
    end

endmodule
