set TOP blink
set OUT build

open_hw_manager
connect_hw_server

set targets [get_hw_targets]
if {[llength $targets] == 0} {
    puts "ERROR: No hw_target found. Check USB connection/power/permissions."
    close_hw_manager
    quit
}
current_hw_target [lindex $targets 0]
open_hw_target

set devs [get_hw_devices]
if {[llength $devs] == 0} {
    puts "ERROR: No hw_device found on target."
    close_hw_manager
    quit
}
set dev [lindex $devs 0]
current_hw_device $dev
refresh_hw_device $dev

set_property PROGRAM.FILE $OUT/$TOP.bit $dev
program_hw_devices $dev

close_hw_manager
quit
