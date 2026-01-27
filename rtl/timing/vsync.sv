`timescale 1ns / 1ps

module vsync #(
    parameter int LINES       = 480,
    parameter int FRONT_PORCH = 11,
    parameter int VSYNC_WIDTH = 2,
    parameter int BACK_PORCH  = 31
)(
    input  logic clk_in,
    input  logic resetn,
    input  logic line_tick,
    output logic v_blank,
    output logic vsync
);

    localparam int V_TOTAL   = LINES + FRONT_PORCH + VSYNC_WIDTH + BACK_PORCH;
    localparam int V_COUNT_W = (V_TOTAL > 1) ? $clog2(V_TOTAL) : 1;

    logic [V_COUNT_W-1:0] v_counter;

    always_ff @(posedge clk_in or negedge resetn) begin
        if (!resetn) begin
            v_counter <= '0;
            v_blank <= '0;
            vsync <= '0;
        end else if (line_tick) begin
            if (v_counter == V_TOTAL - 1) begin
                v_counter <= '0;
            end else begin
                v_counter <= v_counter + 1'b1;
            end

            v_blank <= (v_counter >= LINES);
            vsync   <= (v_counter >= (LINES + FRONT_PORCH)) &&
                       (v_counter <  (LINES + FRONT_PORCH + VSYNC_WIDTH));
        end
    end

endmodule
