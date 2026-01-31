`timescale 1ns / 1ps

module vsync #(
    parameter int LINES       = 480,
    parameter int FRONT_PORCH = 10,
    parameter int VSYNC_WIDTH = 2,
    parameter int BACK_PORCH  = 33,
    parameter int H_TOTAL     = 800,
    parameter bit SYNC_ACTIVE_LOW = 1'b1
)(
    input  logic clk_in,
    input  logic resetn,
    input  logic [$clog2(H_TOTAL)-1:0] h_count,
    output logic v_blank,
    output logic vsync,
    output logic [V_COUNT_W-1:0] v_count
);

    localparam int V_TOTAL   = LINES + FRONT_PORCH + VSYNC_WIDTH + BACK_PORCH;
    localparam int V_COUNT_W = (V_TOTAL > 1) ? $clog2(V_TOTAL) : 1;

    logic [V_COUNT_W-1:0] v_counter;

    logic vsync_raw;

    always_ff @(posedge clk_in or negedge resetn) begin
        if (!resetn) begin
            v_counter <= '0;
            v_blank <= '0;
            vsync_raw <= '0;
        end else begin
            if (h_count == H_TOTAL - 1) begin
                if (v_counter == V_TOTAL - 1) begin
                    v_counter <= '0;
                end else begin
                    v_counter <= v_counter + 1'b1;
                end
            end

            v_blank <= (v_counter >= LINES);
            vsync_raw <= (v_counter >= (LINES + FRONT_PORCH)) &&
                         (v_counter <  (LINES + FRONT_PORCH + VSYNC_WIDTH));
        end
    end

    assign v_count = v_counter;
    assign vsync = SYNC_ACTIVE_LOW ? ~vsync_raw : vsync_raw;

endmodule
