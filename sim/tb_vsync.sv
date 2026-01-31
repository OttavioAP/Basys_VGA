`timescale 1ns/1ps

module tb_vsync;
    localparam int LINES       = 6;
    localparam int FRONT_PORCH = 1;
    localparam int VSYNC_WIDTH = 2;
    localparam int BACK_PORCH  = 1;
    localparam int H_TOTAL     = 16;
    localparam int V_TOTAL     = LINES + FRONT_PORCH + VSYNC_WIDTH + BACK_PORCH;
    localparam int H_COUNT_W   = (H_TOTAL > 1) ? $clog2(H_TOTAL) : 1;

    logic clk = 0;
    logic resetn = 0;
    logic [H_COUNT_W-1:0] h_count = '0;
    logic v_blank;
    logic vsync;

    always #5 clk = ~clk;

    vsync #(
        .LINES(LINES),
        .FRONT_PORCH(FRONT_PORCH),
        .VSYNC_WIDTH(VSYNC_WIDTH),
        .BACK_PORCH(BACK_PORCH)
    ) dut (
        .clk_in(clk),
        .resetn(resetn),
        .h_count(h_count),
        .v_blank(v_blank),
        .vsync(vsync),
        .v_count()
    );

    initial begin
        $dumpfile("sim/build/vsync.vcd");
        $dumpvars(1, tb_vsync.dut);

        repeat (2) @(posedge clk);
        resetn = 1;

        repeat (V_TOTAL * 3 * H_TOTAL) begin
            @(posedge clk);
            if (h_count == H_TOTAL - 1) begin
                h_count <= '0;
            end else begin
                h_count <= h_count + 1'b1;
            end
        end

        $finish;
    end
endmodule
