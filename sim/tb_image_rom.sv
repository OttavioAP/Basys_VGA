`timescale 1ns/1ps

module tb_image_rom;
    localparam int IMG_W = 640;
    localparam int IMG_H = 480;
    localparam int IMG_SIZE = IMG_W * IMG_H;
    localparam int ADDR_W = $clog2(IMG_SIZE);

    logic clk = 0;
    logic [ADDR_W-1:0] addr = '0;
    logic [3:0] pixel;

    always #5 clk = ~clk;

    image_rom #(
        .IMG_W(IMG_W),
        .IMG_H(IMG_H),
        .MEM_FILE("rtl/timing/image/stella.mem")
    ) dut (
        .clk(clk),
        .addr(addr),
        .pixel(pixel)
    );

    initial begin
        $dumpfile("sim/build/image_rom.vcd");
        $dumpvars(1, tb_image_rom.dut);

        repeat (4) @(posedge clk);
        addr <= '0;
        @(posedge clk);
        addr <= 19'd1;
        @(posedge clk);
        addr <= 19'd2;
        @(posedge clk);
        addr <= 19'd307199;
        @(posedge clk);
        $finish;
    end
endmodule
