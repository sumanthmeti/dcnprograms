#Create Simulator
set ns [new Simulator]
#Open trace and NAM trace file
set ntrace [open prog4.tr w]
$ns trace-all $ntrace
set namfile [open prog4.nam w]
$ns namtrace-all $namfile
#Finish Procedure
proc Finish {} {
global ns ntrace namfile
#Dump all trace data and close the file
$ns flush-trace
close $ntrace
close $namfile
#Execute the nam animation file
exec nam prog4.nam &
exit 0
}
#Create 3 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
$ns duplex-link $n0 $n1 1Mb 10ms DropTail
$ns duplex-link $n1 $n2 1Mb 10ms DropTail
#Define the recv function for the class 'Agent/Ping'
Agent/Ping instproc recv {from rtt} {
$self instvar node_
puts "$from received ping answer from node [$node_ id] with round trip time $rtt ms"
}
#Create two ping agents and attach them to n(0) and n(2)
set p0 [new Agent/Ping]
$ns attach-agent $n0 $p0
set p1 [new Agent/Ping]
$ns attach-agent $n2 $p1
$ns connect $p0 $p1
#Schedule events
$ns at 0.2 "$p0 send"
$ns at 0.4 "$p1 send"
$ns at 1.2 "$p0 send"
$ns at 1.7 "$p1 send"
$ns at 1.8 "Finish"
#Run the Simulation
$ns run
