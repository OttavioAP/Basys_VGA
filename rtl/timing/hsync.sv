`timescale 1ns / 1ps

module hsync #(
    parameter int LINE_WIDTH  = 640,
    parameter int FRONT_PORCH = 16,
    parameter int HSYNC_WIDTH = 96,
    parameter int BACK_PORCH  = 48,
    parameter bit SYNC_ACTIVE_LOW = 1'b1
) (
    input  logic clk_in,
    input  logic resetn,
    output logic h_blank,
    output logic hsync,
    output logic [H_COUNT_W-1:0] h_count
);

    localparam int H_TOTAL = LINE_WIDTH + FRONT_PORCH + HSYNC_WIDTH + BACK_PORCH;
    localparam int H_COUNT_W = (H_TOTAL > 1) ? $clog2(H_TOTAL) : 1;

    logic [H_COUNT_W-1:0] h_counter;

    logic hsync_raw;

    always_ff @(posedge clk_in or negedge resetn) begin
        if (!resetn) begin
            h_counter <= '0;
            h_blank   <= 1'b0;
            hsync_raw <= 1'b0;
        end else begin
            if (h_counter == H_TOTAL - 1) begin
                h_counter <= '0;
            end else begin
                h_counter <= h_counter + 1'b1;
            end

            h_blank <= (h_counter >= LINE_WIDTH);
            hsync_raw <= (h_counter >= (LINE_WIDTH + FRONT_PORCH)) &&
                         (h_counter <  (LINE_WIDTH + FRONT_PORCH + HSYNC_WIDTH));
        end
    end

    assign h_count = h_counter;
    assign hsync = SYNC_ACTIVE_LOW ? ~hsync_raw : hsync_raw;

endmodule
