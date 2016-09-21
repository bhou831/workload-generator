#!/usr/bin/perl -w

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);

my $repeat=1;
my @array;
$repeat=$ARGV[(@ARGV-1)];
for(my $i=0;$i<@ARGV;$i++){
   $array[$i]=$ARGV[$i];
}

while($repeat>0){
    #&resubmit(@array);
    &checkJobs;
    &resubmit(@array);
    $repeat--;
    #print $repeat."\n";
}

sub checkJobs{
    my @jobarray;
    while(1){
        @jobarray=`hadoop job -list | grep NORMAL`;
        #print "Jobs submitted last time are still running! \n";
        #for (my $k=0;$k<@jobarray;$k++){
        #    print $jobarray[$k]."\n";
        #}
	if(@jobarray eq 0){
            #print "Jobs submitted last time are still running! \n";
	    #for (my $k=0;$k<@jobarray;$k++){
		#print $jobarray[$k]."\n";
	    #}
	    last;
        }
	print "Sleep 10 seconds!\n";
        sleep 10;
    }
}

sub resubmit{
    my @simulatefile=@_;
    my $i;
    my $j;
    my $parameter;
    my @jobStart;
    my $jobstart=1999999999999;
    my @sleeptime;
    my $tmp=0;
    my $pwd;
    my %log;
    my %simulate;
    my %timexchange;
    my %simulateContent;
    my %logContent;
    my @curTime;
    my $date=`date +%y-%m-%d-%H-%M-%S`;
    my $curTime;
    my $command;
    my $logkey;
    chomp($date);
    print $date;
    mkdir $date;
    #`cp -f ../wordCount.jar .`;
    #eliminate previous output directory
    `hadoop fs -rmr /user/generator/out*`;
    `hadoop fs -rmr /user/generator/sim*`;
    foreach $parameter (@ARGV){
        if($parameter=~m/^simulate(\d+)\.sh$/){
	    $tmp=$1;
            if($jobstart>$tmp)
	    {   
	        $jobstart=$tmp;   
	    }
    	    push(@jobStart,$tmp);
            open(SIM,"$parameter")||die "Can not open simulate file";
	    while(<SIM>){
		my $line=$_;
		if($line=~m/hadoop/){
	 	    $simulate{$tmp}{"command"}=$line;
		    print $line."\n";
		}
		elsif($line=~m/date/){
	  	    $simulate{$tmp}{"date"}=$line;
		}
            }
	    close SIM;
        }
    }

    open(LOG,"log.txt")||die "Can not open log file";
    while(<LOG>){
        my ($seq,$jobtime,$blocknum,$blockdetail)=split(":");
	$log{$jobtime}{"seq"}=$seq;
        $log{$jobtime}{"blocknum"}=$blocknum;
	$log{$jobtime}{"blockdetail"}=$blockdetail;
    }
    close LOG;
#sort the job array
for ($i=0;$i<@jobStart;$i++){
    for($j=0;$j<@jobStart-1;$j++){
        if($jobStart[$j]>$jobStart[$j+1]){
	    $jobStart[$j]=$jobStart[$j]+$jobStart[$j+1];
	    $jobStart[$j+1]=$jobStart[$j]-$jobStart[$j+1];
	    $jobStart[$j]=$jobStart[$j]-$jobStart[$j+1];
 #           print "$jobStart[$j]\n";
	}
	else{
	    next;
 	}
    }
}
#print \@jobStart;
for( $j=0; $j<@jobStart-1;$j++){
    $sleeptime[$j]=int(($jobStart[$j+1]-$jobStart[$j]));
    #print "$sleeptime[$j]\n";
}
$i=0;
$j=0;

#open(LOG,"log.txt")||die "Can not open log file";
#my @log=<LOG>;
#for($i=0;$i<@log;$i++){
#    my ($seqnum,$t,$total,$detail)=split(":",$log[$i]);
#    $logContent{$seqnum}{"time"}=$t;
#    $logContent{$seqnum}{"total"}=$total;
#    $logContent{$seqnum}{"detail"}=$detail;
#}
#close LOG;

while($i<@jobStart){
    if($i==0){ 
        $curTime = int(gettimeofday*1000);
		open(START,">$date/startTime.txt")||die "Can not open the startTime file";
		print START int($curTime/1000)."\n";
		close START;
    }
    else{
         $curTime+=$sleeptime[$i-1];
    }
	$timexchange{$jobStart[$i]}=$curTime;
    open(OUT,">$date/simulate$curTime.sh")||die "Can not construct new file for submission";
    print OUT $simulate{$jobStart[$i]}{"command"}."\n";
	if ($simulate{$jobStart[$i]}{"date"}=~s/finishTime_(\d+)\.txt/$date\/finishTime_$timexchange{$jobStart[$i]}\.txt/) {
		#print $simulate{$jobStart[$i]}{"date"};
		print OUT $simulate{$jobStart[$i]}{"date"};
	}
    close OUT;
    $command="sh $date/simulate$curTime.sh &\n";
    #print "$command\tStart at:$j\n";

    #get current time in millisecond
    $curTime = int(gettimeofday*1000); 
    print $curTime."\t";

    system($command);
    if($i==@jobStart-1){last;}
    print "Sleep for ".($sleeptime[$i]/1000)."seconds\n";
    $j+=$sleeptime[$i];
    sleep int($sleeptime[$i]/1000);
    $i++;
}

#dump log information to a new file
    open(LOG_O,">$date/log.txt")||die "Can not write to log file";
    foreach $logkey (sort keys (%log)) {
	#print $log{$logkey}{"seq"}.":".$timexchange{$logkey}.":".$log{$logkey}{"blocknum"}.":".$log{$logkey}{"blockdetail"};
	print LOG_O $log{$logkey}{"seq"}.":".$timexchange{$logkey}.":".$log{$logkey}{"blocknum"}.":".$log{$logkey}{"blockdetail"};
    }
    close LOG_O;
}
