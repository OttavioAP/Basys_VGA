`timescale 1ns / 1ps

module basys_vga #(
    parameter integer IMG_W         = 640,
    parameter integer IMG_H         = 480,
    parameter integer LINE_WIDTH    = IMG_W,
    parameter integer H_FRONT_PORCH = 16,
    parameter integer H_SYNC_WIDTH  = 96,
    parameter integer H_BACK_PORCH  = 48,
    parameter integer LINES         = IMG_H,
    parameter integer V_FRONT_PORCH = 10,
    parameter integer V_SYNC_WIDTH  = 2,
    parameter integer V_BACK_PORCH  = 33,
    parameter MEM_FILE              = "rtl/timing/image/stella.mem"
)(
    input  logic       clk,
    input  logic       reset,
    output logic [3:0] vgaRed,
    output logic [3:0] vgaGreen,
    output logic [3:0] vgaBlue,
    output logic       Hsync,
    output logic       Vsync,
    output logic       led
);

    localparam integer H_TOTAL   = LINE_WIDTH + H_FRONT_PORCH + H_SYNC_WIDTH + H_BACK_PORCH;
    localparam integer V_TOTAL   = LINES + V_FRONT_PORCH + V_SYNC_WIDTH + V_BACK_PORCH;
    localparam integer H_COUNT_W = (H_TOTAL > 1) ? $clog2(H_TOTAL) : 1;
    localparam integer V_COUNT_W = (V_TOTAL > 1) ? $clog2(V_TOTAL) : 1;
    localparam integer IMG_SIZE  = IMG_W * IMG_H;
    localparam integer ADDR_W    = (IMG_SIZE > 1) ? $clog2(IMG_SIZE) : 1;

    logic resetn;
    assign resetn = ~reset;

    wire pixel_clk;
    wire locked;

    pixel_clock_gen clkgen (
        .clk_in(clk),
        .resetn(resetn),
        .pixel_clk(pixel_clk),
        .locked(locked)
    );

    wire resetn_sync;
    assign resetn_sync = resetn & locked;

    logic h_blank;
    logic v_blank;
    logic rgb_vis;
    logic [H_COUNT_W-1:0] h_count;
    logic [V_COUNT_W-1:0] v_count;

    hsync #(
        .LINE_WIDTH(LINE_WIDTH),
        .FRONT_PORCH(H_FRONT_PORCH),
        .HSYNC_WIDTH(H_SYNC_WIDTH),
        .BACK_PORCH(H_BACK_PORCH)
    ) hsync_inst (
        .clk_in(pixel_clk),
        .resetn(resetn_sync),
        .h_blank(h_blank),
        .hsync(Hsync),
        .h_count(h_count)
    );

    vsync #(
        .LINES(LINES),
        .FRONT_PORCH(V_FRONT_PORCH),
        .VSYNC_WIDTH(V_SYNC_WIDTH),
        .BACK_PORCH(V_BACK_PORCH),
        .H_TOTAL(H_TOTAL)
    ) vsync_inst (
        .clk_in(pixel_clk),
        .resetn(resetn_sync),
        .h_count(h_count),
        .v_blank(v_blank),
        .vsync(Vsync),
        .v_count(v_count)
    );

    rgb_visibility rgb_vis_inst (
        .hblank(h_blank),
        .vblank(v_blank),
        .rgb_visibility(rgb_vis)
    );

    logic [ADDR_W-1:0] img_addr;
    localparam integer HEARTBEAT_DIV = 24;
    logic [HEARTBEAT_DIV-1:0] heartbeat_cnt;

    always_ff @(posedge pixel_clk or negedge resetn_sync) begin
        if (!resetn_sync) begin
            img_addr <= '0;
        end else begin
            if (rgb_vis) begin
                img_addr <= (v_count * IMG_W) + h_count;
            end else begin
                img_addr <= '0;
            end
        end
    end

    logic [3:0] pixel;
    image_rom #(
        .IMG_W(IMG_W),
        .IMG_H(IMG_H),
        .MEM_FILE(MEM_FILE)
    ) image_rom_inst (
        .clk(pixel_clk),
        .addr(img_addr),
        .pixel(pixel)
    );

    always_comb begin
        if (rgb_vis) begin
            vgaRed   = pixel;
            vgaGreen = pixel;
            vgaBlue  = pixel;
        end else begin
            vgaRed   = 4'b0000;
            vgaGreen = 4'b0000;
            vgaBlue  = 4'b0000;
        end
    end

    always_ff @(posedge pixel_clk or negedge resetn_sync) begin
        if (!resetn_sync) begin
            heartbeat_cnt <= '0;
            led <= 1'b0;
        end else begin
            heartbeat_cnt <= heartbeat_cnt + 1'b1;
            led <= heartbeat_cnt[HEARTBEAT_DIV-1];
        end
    end

endmodule
