module image_rom #(
    parameter int unsigned IMG_W     = 640,
    parameter int unsigned IMG_H     = 480,
    parameter string       MEM_FILE  = "rtl/timing/image/stella.mem"
) (
    input  logic                          clk,
    input  logic [$clog2(IMG_W*IMG_H)-1:0] addr,
    output logic [3:0]                    pixel
);

    localparam int unsigned IMG_SIZE = IMG_W * IMG_H;

    logic [3:0] rom [0:IMG_SIZE-1];

    initial begin
        $readmemb(MEM_FILE, rom);
    end

    always_ff @(posedge clk) begin
        pixel <= rom[addr];
    end

endmodule
