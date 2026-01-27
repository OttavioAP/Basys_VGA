`timescale 1ns / 1ps

module pixel_clock_gen #(
    parameter real CLKIN_FREQ_MHZ    = 100.0,
    parameter real TARGET_FREQ_MHZ   = 25.175,
    parameter real CLKFBOUT_MULT_F   = 9.0,
    parameter real DIVCLK_DIVIDE     = 1.0,
    parameter real CLKOUT_PHASE      = 0.0,
    parameter real CLKOUT_DUTY       = 0.5,
    parameter string BANDWIDTH       = "OPTIMIZED"
) (
    input  wire clk_in,
    input  wire resetn,
    output wire pixel_clk,
    output wire locked
);

    localparam real CLKOUT0_DIVIDE_F = (CLKIN_FREQ_MHZ * CLKFBOUT_MULT_F) /
                                       (DIVCLK_DIVIDE * TARGET_FREQ_MHZ);

    wire clk_in_buf;
    wire clkfb;
    wire clkfb_buf;
    wire clk_mmcm;

    IBUF clk_ibuf (
        .I(clk_in),
        .O(clk_in_buf)
    );

    BUFG clkfb_bufg (
        .I(clkfb),
        .O(clkfb_buf)
    );

    BUFG clkout_bufg (
        .I(clk_mmcm),
        .O(pixel_clk)
    );

    MMCME2_BASE #(
        .BANDWIDTH(BANDWIDTH),
        .CLKFBOUT_MULT_F(CLKFBOUT_MULT_F),
        .CLKIN1_PERIOD(1000.0 / CLKIN_FREQ_MHZ),
        .CLKFBOUT_PHASE(0.0),
        .CLKOUT0_DIVIDE_F(CLKOUT0_DIVIDE_F),
        .CLKOUT0_PHASE(CLKOUT_PHASE),
        .CLKOUT0_DUTY_CYCLE(CLKOUT_DUTY),
        .DIVCLK_DIVIDE(DIVCLK_DIVIDE),
        .STARTUP_WAIT("FALSE")
    ) mmcm_inst (
        .CLKIN1(clk_in_buf),
        .CLKFBIN(clkfb_buf),
        .CLKFBOUT(clkfb),
        .CLKOUT0(clk_mmcm),
        .LOCKED(locked),
        .RST(~resetn),
        .PWRDWN(1'b0)
    );

endmodule
