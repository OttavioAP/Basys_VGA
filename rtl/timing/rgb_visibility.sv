`timescale 1ns/1ps

module rgb_visibility(
    input logic hblank,
    input logic vblank,
    output logic rgb_visibility
);

assign rgb_visibility = !(hblank || vblank);

endmodule
