proc getenv_or {name default} {
    if {[info exists ::env($name)] && $::env($name) ne ""} {
        return $::env($name)
    }
    return $default
}

set MODE [string tolower [getenv_or MODE bitstream]]
set TOP  [getenv_or TOP pixel_clock_gen]
set PART [getenv_or PART xc7a35tcpg236-1]
set OUT  [getenv_or OUT build]

file mkdir $OUT

set script_dir [file normalize [file dirname [info script]]]
set rtl_dir [file join $script_dir .. rtl]
set xdc_file [file join $script_dir .. constraints basys3.xdc]

set rtl_files [glob -nocomplain -directory $rtl_dir *.sv */*.sv */*/*.sv]
foreach rtl_file $rtl_files {
    read_verilog -sv $rtl_file
}

if {$MODE eq "synth"} {
    # Out-of-context synthesis avoids board pin/IOSTANDARD DRCs.
    synth_design -top $TOP -part $PART -mode out_of_context
    report_timing_summary -file [file join $OUT ${TOP}_timing_ooc.rpt]
} else {
    read_xdc $xdc_file
    synth_design -top $TOP -part $PART
    opt_design
    place_design
    route_design
    write_bitstream -force [file join $OUT ${TOP}.bit]
}

quit
