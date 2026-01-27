module blink (
    input  logic clk,        // 100 MHz clock
    input  logic reset,        // active-high reset
    output logic led
);

    // 50 million cycles = 0.5 seconds
    `ifdef SIM
     	localparam int COUNT_MAX = 10;
    `else
        localparam int COUNT_MAX = 25_000_000;
    `endif


    int counter;

    always_ff @(posedge clk) begin
        if (reset) begin
            counter <= 0;
            led     <= 1'b0;
        end else begin
            if (counter == COUNT_MAX - 1) begin
                counter <= 0;
                led     <= ~led;
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule
