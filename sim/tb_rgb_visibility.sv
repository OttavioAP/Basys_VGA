`timescale 1ns/1ps

module tb_rgb_visibility;
    logic hblank = 0;
    logic vblank = 0;
    logic rgb_visibility;

    rgb_visibility dut (
        .hblank(hblank),
        .vblank(vblank),
        .rgb_visibility(rgb_visibility)
    );

    initial begin
        $dumpfile("sim/build/rgb_visibility.vcd");
        $dumpvars(1, tb_rgb_visibility.dut);

        #10 hblank = 1;
        #10 vblank = 1;
        #10 hblank = 0;
        #10 vblank = 0;
        #10;
        $finish;
    end
endmodule
