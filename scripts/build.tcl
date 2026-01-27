set TOP blink
set PART xc7a35tcpg236-1
set OUT build

file mkdir $OUT

read_verilog rtl/blink.sv
read_xdc constraints/basys3.xdc

synth_design -top $TOP -part $PART
opt_design
place_design
route_design

write_bitstream -force $OUT/$TOP.bit
quit
