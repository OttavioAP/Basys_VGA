`timescale 1ns/1ps

module tb_pixel_clock_gen;
    logic clk_in = 0;
    logic resetn = 0;
    wire pixel_clk;
    wire locked;

    always #5 clk_in = ~clk_in;

    pixel_clock_gen dut (
        .clk_in(clk_in),
        .resetn(resetn),
        .pixel_clk(pixel_clk),
        .locked(locked)
    );

    initial begin
        $dumpfile("sim/build/pixel_clock_gen.vcd");
        $dumpvars(1, tb_pixel_clock_gen.dut);

        #20 resetn = 1;
        repeat (50) @(posedge clk_in);
        $finish;
    end
endmodule
