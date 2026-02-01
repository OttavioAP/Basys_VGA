`timescale 1ns/1ps

module IBUF(
    input  wire I,
    output wire O
);
    assign O = I;
endmodule

module BUFG(
    input  wire I,
    output wire O
);
    assign O = I;
endmodule

module MMCME2_BASE #(
    parameter BANDWIDTH = "OPTIMIZED",
    parameter real   CLKFBOUT_MULT_F = 1.0,
    parameter real   CLKIN1_PERIOD = 10.0,
    parameter real   CLKFBOUT_PHASE = 0.0,
    parameter real   CLKOUT0_DIVIDE_F = 1.0,
    parameter real   CLKOUT0_PHASE = 0.0,
    parameter real   CLKOUT0_DUTY_CYCLE = 0.5,
    parameter real   DIVCLK_DIVIDE = 1.0,
    parameter STARTUP_WAIT = "FALSE"
) (
    input  wire CLKIN1,
    input  wire CLKFBIN,
    output wire CLKFBOUT,
    output wire CLKOUT0,
    output wire LOCKED,
    input  wire RST,
    input  wire PWRDWN
);
    assign CLKFBOUT = CLKFBIN;
    assign CLKOUT0  = CLKIN1;
    assign LOCKED   = ~RST & ~PWRDWN;
endmodule
