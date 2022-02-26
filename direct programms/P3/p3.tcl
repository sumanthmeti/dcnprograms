#Simulate an Ethernet LAN using N nodes. Determine collision across different nodes.
set ns [new Simulator]
set trf [open 6.tr w]
$ns trace-all $trf
set naf [open 6.nam w]
$ns namtrace-all $naf
#to create nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set lan [$ns newLan "$n0 $n1 $n2 $n3
$n4 $n5" 5Mb 10ms LL Queue/DropTail Channel]
set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp
set ftp [new Application/FTP]
$ftp attach-agent $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n2 $sink
$ns connect $tcp $sink
set udp [new Agent/UDP]
$ns attach-agent $n1 $udp
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
set null [new Agent/Null]
$ns attach-agent $n3 $null
$ns connect $udp $null
proc finish {} {
global ns naf trf
$ns flush-trace
exec nam 6.nam &
close $trf
close $naf
exec echo "The number of packet drops due to collision is" &
exec grep -c "^d" 6.tr &
exit 0
}
$ns at 0.1 "$cbr start"
$ns at 2.0 "$ftp start"
$ns at 1.9 "$cbr stop"
$ns at 4.3 "$ftp stop"
$ns at 6.0 "finish"
$ns run
