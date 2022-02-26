#Simulate a four node point-to-point network, and connect the links as follows: n0-n2, n1-n2 and n2-n3.Apply TCP agent between n0-n3 and UDP n1-n3. Apply relevant applications over TCP and UDP agents changing the parameter and determine the number of packets sent by TCP/UDP.
set ns [new Simulator]
set ntrace [open prog2.tr w]
$ns trace-all $ntrace
set namfile [open prog2.nam w]
$ns namtrace-all $namfile
proc Finish {} {
global ns ntrace namfile
$ns flush-trace
close $ntrace
close $namfile
exec nam prog2.nam &
exec echo "The number of TCP packets sent are" &
exec grep "^+" prog2.tr | cut -d " " -f 5 | grep -c "tcp" &
exec echo "The number of UDP packets sent are" &
exec grep "^+" prog2.tr | cut -d " " -f 5 | grep -c "cbr" &
exit 0
}
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns duplex-link $n2 $n3 2Mb 10ms DropTail
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set sink0 [new Agent/TCPSink]
$ns attach-agent $n3 $sink0
$ns connect $tcp0 $sink0
set udp0 [new Agent/UDP]
$ns attach-agent $n1 $udp0
set null0 [new Agent/Null]
$ns attach-agent $n3 $null0
$ns connect $udp0 $null0
set ftp0 [new Application/FTP]
$ftp0 set type_ FTP
$ftp0 attach-agent $tcp0
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0
$ns at 0.1 "$cbr0 start"
$ns at 1.5 "$ftp0 start"
$ns at 1.0 "$cbr0 stop"
$ns at 2.5 "$ftp0 stop"
$ns at 5.0 "Finish"
$ns run
