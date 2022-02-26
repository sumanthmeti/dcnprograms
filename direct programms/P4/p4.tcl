#Simulate an Ethernet LAN using N-nodes(1-7), and determine the throughput
set ns [new Simulator]
set trf [open prog5.tr w]
$ns trace-all $trf
set naf [open prog5.nam w]
$ns namtrace-all $naf
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
set lan [$ns newLan "$n0 $n1 $n2 $n3 $n4 $n5 $n6 $n7" 5Mb 10ms LL Queue/DropTail Channel]
set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp
set ftp [new Application/FTP]
$ftp attach-agent $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n7 $sink
$ns connect $tcp $sink
set udp [new Agent/UDP]
$ns attach-agent $n1 $udp
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
set null [new Agent/Null]
$ns attach-agent $n5 $null
$ns connect $udp $null
proc finish {} {
global ns naf trf
$ns flush-trace
exec nam prog5.nam &
close $trf
close $naf
set tcpsize [ exec grep "^r" prog5.tr | grep "tcp" | tail -n 1 | cut -d " " -f 6]
set numtcp [ exec grep "^r" prog5.tr | grep -c "tcp"]
set tcptime 2.3
set udpsize [ exec grep "^r" prog5.tr | grep "cbr" | tail -n1 | cut -d " " -f6]
set numudp [ exec grep "^r" prog5.tr | grep -c "cbr"]
set udptime 4.0
puts "The throughput of FTP is"
puts "[ expr ($numtcp*$tcpsize)/$tcptime] bytes per second"
puts "The throughput of CBR is"
puts "[ expr ($numudp*$udpsize)/$udptime] bytes per second"
exit 0
}
$ns at 0.1 "$cbr start"
$ns at 2.0 "$ftp start"
$ns at 1.9 "$cbr stop"
$ns at 4.3 "$ftp stop"
$ns at 6.0 "finish"
$ns run
