proc idcode {} {
	ir_shift 100100
    dr_shift 00000000


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
 proc dr_shift {sequence} {
 #add four zeros if using raw jtag
	set seqname [jtag sequence]
	
	$seqname drshift -state IDLE -capture -hex [expr [string length $sequence]*4] $sequence 

	set result [$seqname run -bits]
    puts [bin_to_hex $result]
	$seqname delete


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
  proc bin_to_hex {sequence} {
    set hex [string'reverse $sequence]
    binary scan [binary format B* $hex] H* bits
    return $bits
 }
 
 proc string'reverse str {
   set res {}
   set i [string length $str]
   while {$i > 0} {append res [string index $str [incr i -1]]}
   set res
}