 # set fp [open "test.bin" r]
 # set file_data [read $fp]
 # binary scan $file_data H* hex
 # set hex
 
 proc bscan_file {filename} {
    set fp [open $filename r]
    fconfigure $fp -translation binary
    set file_data [read $fp]
    binary scan $file_data H* hex
    set hex
    
    bscan $hex
 
 
 }
 
 
 proc bscan_16 {sequence} {
    bscan $sequence
    bscan $sequence
    bscan $sequence
    bscan $sequence
    bscan $sequence
    bscan $sequence
    bscan $sequence
    bscan $sequence
    bscan $sequence
    bscan $sequence
    bscan $sequence
    bscan $sequence
    bscan $sequence
    bscan $sequence
    bscan $sequence
    bscan $sequence

 }
 proc bscan {sequence} {
 #add four zeros if using raw jtag
	set seqname [jtag sequence]
    $seqname state RESET

	$seqname irshift -state IDLE -bits 6 010000
	#puts [expr [string length $sequence]*4]
    [binary scan [binary format H* $sequence] B* bits]
    #puts $bits
	$seqname drshift -state IDLE -capture -bits [expr [string length $sequence]*4] $bits
    
	set result [$seqname run -bits]
    puts [bin_to_hex $result]
	$seqname delete
    


 }
 

proc idcode {} {
	ir_shift 100100
    dr_shift_lsb 00000000


}



#this does an IR shift to the FPGA for a KINTEX7
proc ir_shift {sequence} {
	set seqname [jtag sequence]

	$seqname state RESET

	$seqname irshift -state IDLE -bits 6 $sequence

	set result [$seqname run]

	$seqname delete


}
#this does an zfR shift to the FPGA for a KINTEX7
 proc dr_shift_lsb {sequence} {
 #add four zeros if using raw jtag
	set seqname [jtag sequence]
	
	$seqname drshift -state IDLE -capture -hex [expr [string length $sequence]*4] $sequence 

	set result [$seqname run -bits]
    puts [bin_to_hex_reverse $result]
	$seqname delete


 }
 proc dr_shift_msb {sequence} {
 #add four zeros if using raw jtag
	set seqname [jtag sequence]
	#puts [expr [string length $sequence]*4]
    [binary scan [binary format H* $sequence] B* bits]
    #puts $bits
	$seqname drshift -state IDLE -capture -bits [expr [string length $sequence]*4] $bits

	set result [$seqname run -bits]
    puts [bin_to_hex $result]
	$seqname delete


 }

 
  proc dr_shift_test {sequence} {
 #add four zeros if using raw jtag
    ir_shift 010000
	set seqname [jtag sequence]
	#puts [expr [string length $sequence]*4]
    [binary scan [binary format H* $sequence] B* bits]
    #puts $bits
	$seqname drshift -state IDLE -capture -tdi 1 32

	puts [set result [$seqname run -bits]]

	#$seqname delete


 }
 
  proc str_length {sequence} {
	set y [string length $sequence]
    set x [expr $y*2]

 }  
 proc hex_test {sequence} {
    set hex $sequence
    binary scan [binary format H* $hex] B* bits
    puts $bits

 }
  proc bin_to_hex_reverse {sequence} {
    set hex [string'reverse $sequence]
    binary scan [binary format B* $hex] H* bits
    return $bits
 }
 
  proc bin_to_hex {sequence} {
    set hex $sequence
    binary scan [binary format B* $hex] H* bits
    return $bits
 }
 proc string'reverse str {
   set res {}
   set i [string length $str]
   while {$i > 0} {append res [string index $str [incr i -1]]}
   set res
}