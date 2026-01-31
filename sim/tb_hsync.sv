`timescale 1ns/1ps

module tb_hsync;
    localparam int LINE_WIDTH  = 8;
    localparam int FRONT_PORCH = 2;
    localparam int HSYNC_WIDTH = 2;
    localparam int BACK_PORCH  = 2;
    localparam int H_TOTAL     = LINE_WIDTH + FRONT_PORCH + HSYNC_WIDTH + BACK_PORCH;

    logic clk = 0;
    logic resetn = 0;
    logic h_blank;
    logic hsync;

    always #5 clk = ~clk;

    hsync #(
        .LINE_WIDTH(LINE_WIDTH),
        .FRONT_PORCH(FRONT_PORCH),
        .HSYNC_WIDTH(HSYNC_WIDTH),
        .BACK_PORCH(BACK_PORCH)
    ) dut (
        .clk_in(clk),
        .resetn(resetn),
        .h_blank(h_blank),
        .hsync(hsync),
        .h_count()
    );

    initial begin
        $dumpfile("sim/build/hsync.vcd");
        $dumpvars(1, tb_hsync.dut);

        repeat (2) @(posedge clk);
        resetn = 1;

        repeat (H_TOTAL * 3) @(posedge clk);
        $finish;
    end
endmodule
