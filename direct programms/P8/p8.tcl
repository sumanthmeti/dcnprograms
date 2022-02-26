set ns [new Simulator]
set nf [open p8.tr w]
$ns trace-all $nf
set ntrace [open p8.nam w]
$ns namtrace-all $ntrace
for {set i 0} { $i<4 } {incr i} {
set n($i) [$ns node] }
for {set i 0} { $i<4 } {incr i} {
$ns duplex-link $n($i) $n([expr ($i+1)%4]) 1Mb 10ms DropTail }
set udp [new Agent/UDP]
set null [new Agent/Null]
$ns attach-agent $n(0) $udp
$ns attach-agent $n(1) $null
$ns connect $udp $null
set cbr [new Application/Traffic/CBR]
$cbr set interval_ 0.005
$cbr set packetSize_ 500
$cbr attach-agent $udp
set udp1 [new Agent/UDP]
set null1 [new Agent/Null]
$ns attach-agent $n(1) $udp1
$ns attach-agent $n(2) $null1
$ns connect $udp1 $null1
set cbr1 [new Application/Traffic/CBR]
$cbr1 set interval_ 0.005
$cbr1 set packetSize_ 500
$cbr1 attach-agent $udp1
set udp2 [new Agent/UDP]
set null2 [new Agent/Null]
$ns attach-agent $n(2) $udp2
$ns attach-agent $n(3) $null2
$ns connect $udp2 $null2
set cbr2 [new Application/Traffic/CBR]
$cbr2 set interval_ 0.005
$cbr2 set packetSize_ 500
$cbr2 attach-agent $udp2
set udp3 [new Agent/UDP]
set null3 [new Agent/Null]
$ns attach-agent $n(3) $udp3
$ns attach-agent $n(0) $null3
$ns connect $udp3 $null3
set cbr3 [new Application/Traffic/CBR]
$cbr3 set interval_ 0.005
$cbr3 set packetSize_ 500
$cbr3 attach-agent $udp3
proc Finish { } {
global ns nf ntrace
$ns flush-trace
close $nf
close $ntrace
exec nam p8.nam &
exit 0
}
$ns at 0.5 "$cbr start"
$ns at 4.5 "$cbr stop"
$ns at 0.5 "$cbr1 start"
$ns at 4.5 "$cbr1 stop"
$ns at 0.5 "$cbr2 start"
$ns at 4.5 "$cbr2 stop"
$ns at 0.5 "$cbr3 start"
$ns at 4.5 "$cbr3 stop"
$ns at 5.0 "Finish"
$ns run
