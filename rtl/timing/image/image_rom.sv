module image_rom #(
    parameter integer IMG_W     = 640,
    parameter integer IMG_H     = 480,
    parameter MEM_FILE          = "rtl/timing/image/stella.mem"
) (
    input  logic                          clk,
    input  logic [$clog2(IMG_W*IMG_H)-1:0] addr,
    output logic [3:0]                    pixel
);

    localparam integer IMG_SIZE = IMG_W * IMG_H;

    logic [3:0] rom [0:IMG_SIZE-1];

    initial begin
        $readmemb(MEM_FILE, rom);
    end

    always_ff @(posedge clk) begin
        pixel <= rom[addr];
    end

endmodule
