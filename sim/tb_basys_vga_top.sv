`timescale 1ns/1ps

module tb_basys_vga_top;
    reg clk = 1'b0;
    reg reset = 1'b1;
    wire [3:0] vgaRed;
    wire [3:0] vgaGreen;
    wire [3:0] vgaBlue;
    wire Hsync;
    wire Vsync;
    wire led;

    // 100 MHz clock (10 ns period).
    always #5 clk = ~clk;

    basys_vga dut (
        .clk(clk),
        .reset(reset),
        .vgaRed(vgaRed),
        .vgaGreen(vgaGreen),
        .vgaBlue(vgaBlue),
        .Hsync(Hsync),
        .Vsync(Vsync),
        .led(led)
    );

    initial begin
        $dumpfile("sim/build/basys_vga_top.vcd");
        $dumpvars(1, tb_basys_vga_top.dut);

        // Release reset after a few cycles.
        repeat (5) @(posedge clk);
        reset = 1'b0;

        // Run long enough to observe sync activity.
        repeat (20000) @(posedge clk);

        $finish;
    end
endmodule
