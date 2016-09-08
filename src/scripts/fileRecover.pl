#!/usr/bin/perl -w

my %logContent;
@array=qw(simulate1288040159905.sh
simulate1288040161658.sh
simulate1288040169549.sh
simulate1288040171868.sh
simulate1288040189420.sh
simulate1288040201075.sh
simulate1288040201167.sh
simulate1288040207641.sh
simulate1288040210850.sh
simulate1288040216434.sh) ;

open(LOG,"./log.txt")||die "Can not open log file";
my @log=<LOG>;
for($i=0;$i<@log;$i++){
    my ($seqnum,$t,$total,$detail)=split(":",$log[$i]);
    $logContent{$seqnum}{"time"}=$t;
    $logContent{$seqnum}{"total"}=$total;
    $logContent{$seqnum}{"detail"}=$detail;
}
close LOG;

open(L2B,"request2Block.txt")||die "Can not open log file";
my %r2b;
while(<L2B>){
    my ($snum,$access)=split(" ",$_);
    $r2b{$snum}=$access;
}



for (my $arraykey=0;$arraykey<@array;$arraykey++){
    open(SIM,">$array[$arraykey]")||die "Can not open file";
    my @blocks=split(",",$logContent{$arraykey+1}{"detail"});
    print SIM "nohup time hadoop jar wordCount.jar wordCount -rnum 10 -input ";
    for( my $blockkey=0;$blockkey< @blocks;$blockkey++){
    	print SIM $r2b{$blocks[$blockkey]}."\t";
    }
    print SIM "-output /user/generator/".$array[$arraykey]."\n";
    if($array[$arraykey]=~m/simulate(\d+)\.sh/){
        my $t=$1;
        print SIM "date +\%s > finishTime_$t\.txt\n";
    }
    
}
