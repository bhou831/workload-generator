#!/usr/bin/perl -w
# This is the metrice retrieving program
#
#
#Eg: perl getProcessMetrics.pl finishTime* log.txt
#
#
#
#use strict;
#use warnings;

use lib qw( /usr/local/rrdtool-1.0.41/lib/perl ../lib/perl );
use RRDs;
use GD::Graph::area;
use GD::Graph::bars;
use GD::Graph::hbars;
use GD::Graph::linespoints;
use GD::Graph::Data;
use Chart::StackedBars;
my $parameter;
my $startTime=9999999999999;
my $stopTime=-1;
my %blockNum;
my @startTimes;
my @stopTimes;
my %blockDetails;
my $counter=-1;
my $incomingData;
my @responseTime;
my $throughput;
my $avgResponse;
my $blockProcessTime;
my $exeTime;
my $totalBlock=0;
my $haveLogFile=0;
my @jobs;
my $jobCounter=0;
my %tasks;
my $jobSubmit;
my $jobStart=9999999999999;
my $jobStop=-1;
my %queueTime;
my %exeTimes;
my $jobname;
my $taskId;
my $jobtime;
my $avgQueueTime=0;
my $rrdPath;
my @stack;
my $filename='';
my $mapstarts=9999999999999;
my $mapstops=0;
my $redstarts=9999999999999;
my $redstops=0;
my $sortstops=0;
my $shufflestops=0;
my %stages;
my $tmp;
my $avgExeTime;
my $realJob=0;
my $avgBlockprocess;
my %estimate;
my $estimateBlockExeTime=0;
my $estimateResponse=0;
my $previousBlockNum=0;
my $previousExeTime=0;
my $estimateTitle;
my @data2plot;
my $pwd;
my $estimateKey;
my $expectedResponse=0;
my %globaljobdetail;
my $timeline;
my $x="";

open(OUT,">>results.txt")||die "Can not open result file";

foreach $parameter (@ARGV) {

	if($parameter=~m/^finishTime_(\d+)\.txt/){
		$counter++;
		#print $counter."\n";
		$incomingData=$1;
		$startTimes[$counter]=$incomingData;
		if ($incomingData lt $startTime) {
			$startTime=$incomingData;
			#print $startTime."\n";
		}
		#print @startTimes."\n";
		open(FIN,"$parameter")|| die "Can not open finishTime file";
		while(<FIN>){
			$stopTimes[$counter]=$_;
			#print $_."\n";
			if($stopTime lt $stopTimes[$counter]){
				$stopTime=$stopTimes[$counter];
				#print $stopTime;
			}
		}
		close FIN;
	}
	elsif($parameter=~m/^log\.txt/){
		open (LOG,"$parameter")||die "Can not open LOG file";
		$haveLogFile=1;
		while(<LOG>){
			#print $_."\n";
			my ($jobSeqNo,$jobStart,$blockNo,$blockDetail)=split(":",$_);
			$blockNum{$jobStart}=$blockNo;
			$totalBlock+=$blockNo;
			$blockDetails{$jobStart}=$blockDetail;
		}
		close LOG;
	}
	elsif($parameter=~m/_che_/){
		$jobCounter++;
		#print $parameter."\n";
		$jobs[$jobCounter]=$parameter;

	}
	elsif($parameter=~m/rrd/){
		$rrdPath=$parameter;
		if ( -d $rrdPath ) {
			&ProcessDir($rrdPath);
		}
		else {
			die "The rrd diretory you input is not currect!";
		}
	}
}
$exeTime=$stopTime-$startTime/1000;
#print $exeTime."\n";
for (my $i=0;$i<@startTimes;$i++){
	$responseTime[$i]=$stopTimes[$i]-$startTimes[$i]/1000;
	$avgResponse+=$responseTime[$i];
}

#print @jobs;
foreach my $j (@jobs) {
	$mapstarts=9999999999999;
	$mapstops=0;
	$redstarts=9999999999999;
	$redstops=0;
	$jobStart=9999999999999;
	$jobStop=-1;
	#print $j;
	if($j=~m/_che_wordcount(\d+)/){
	    $jobtime=$1/1000;
	    if($j=~m/job_(\w+)_che/){
		    $jobname=$1;
		}
		#print $jobname."\n";
		#print ($jobtime/1000)."\t".$startTime."\t".$stopTime."\n";
		if ($jobtime > $startTime/1000 and $jobtime < $stopTime) {
			#print $jobtime."\t".$startTime."\t".$stopTime."\t".$j."\n";
			open(HLOG,"$j")||die "Can not open hadoop log file";
			my @array=<HLOG>;
			for(my $k=0;$k<@array;$k++){
				my $line=$array[$k];
				#print $line."\n";
			if(!($line=~m/TASK_TYPE=\"SETUP\"/) and !($line=~m/TASK_TYPE=\"CLEANUP\"/) ){
				if($line=~m/SUBMIT_TIME=\"(\d+)\"/){
					my $jobSubmit=$1;
				}
				elsif($line=~m/Task TASKID=\"(\w+)\"/){
					my $taskId=$1;
					if($line=~m/START_TIME=\"(\d+)\"/){
						$tasks{$taskId}{"start"}=$1;

						#print $line."\n";
						if ($line=~m/TASK_TYPE=\"MAP\"/) {
							#print $jobStart."jobstart\n";
							if($jobStart> $tasks{$taskId}{"start"}){
								$jobStart=$tasks{$taskId}{"start"};

								#print $jobStart."jobstart\n";
							}
						}
						if($line=~m/SPLITS=\"(\S+)\"/){
							#print $1."Got it!!!\n";
							$tasks{$taskId}{"datasource"}=$1;
						}
					}
					elsif($line=~m/FINISH_TIME=\"(\d+)\"/){
						$tasks{$taskId}{"stop"}=$1;
						if($jobStop < $tasks{$taskId}{"stop"}){
							$jobStop = $tasks{$taskId}{"stop"};
							#print $jobStop."jobstop\n";
						}
					}
				}
				elsif($line=~m/MapAttempt/){
					if ($line=~m/TASKID=\"(\S+)\"/) {
						my $taskid=$1;
						if($line=~m/TASK_TYPE=\"MAP\"/){
								if ($line=~m/START_TIME=\"(\d+)\"/) {
									$tmp=$1;
									#print "mapstart:$tmp\n";
									if ($tmp<$mapstarts){
										$mapstarts=$tmp;
									}
									$stages{$jobname}{"mapstart"}=$mapstarts;
									$globaljobdetail{$mapstarts}{"mapstart"}=1;
									$globaljobdetail{$mapstarts}{"jobname"}=$jobname;
								}
							if ($line=~m/TASK_STATUS=\"SUCCESS\"/) {

								if ($line=~m/HOSTNAME=\"(\S+)\"/) {
									$tasks{$taskid}{"location"}=$1;
								}

								if ($line=~m/FINISH_TIME=\"(\d+)\"/) {
									$tmp=$1;
									if ($tmp>$mapstops){
										$mapstops=$tmp;
									}
									#print "mapstop:$mapstops\n";
									$stages{$jobname}{"mapstop"}=$mapstops;
 
								}
							}
						}
					}
				}
				elsif($line=~m/ReduceAttempt/){
					if ($line=~m/TASKID=\"(\S+)\"/) {
							my $taskid=$1;
					if($line=~m/TASK_TYPE=\"REDUCE\"/){
						if ($line=~m/START_TIME=\"(\d+)\"/) {
                                $tmp=$1;
								#print "redstart:$1\n";
								if ($tmp<$redstarts){
									$redstarts=$tmp;
								}
								$stages{$jobname}{"redstart"}=$redstarts;
                        }
					if ($line=~m/TASK_STATUS=\"SUCCESS\"/) {

							if ($line=~m/HOSTNAME=\"(\S+)\"/) {
								$tasks{$taskid}{"location"}=$1;
							}
							
#							if ($line=~m/SHUFFLE_FINISH=\"(\d+)\"/) {
 #                               $tmp=$1;
#								if ($tmp>$redstarts){
#									$redstarts=$tmp;
#								}
 #                               if ($stages{$jobname}{"shufflestop"}<$stops){
#								    $stages{$jobname}{"shufflestop"}=$stops;
#								}
 #                           }
#							if ($line=~m/SHUFFLE_FINISH=\"(\d+)\"/) {
#                                $stops=$1;
								#print "$1\n";
 #                               if ($stages{$jobname}{"sortstop"}<$stops){
#								    $stages{$jobname}{"sortstop"}=$stops;
#								}
#                            }
							if ($line=~m/FINISH_TIME=\"(\d+)\"/) {
                                 #print "$1\n";
								 $tmp=$1;
								 if ($tmp>$redstops){
									$redstops=$tmp;
								 }
								# print "reducestop:$redstops.\n";
								 $stages{$jobname}{"redstop"}=$redstops; 
                            }
						}
						}
					}
				}
			}
		}
			#print $jobname."jobname\n";
			$queueTime{$jobname}=$jobStart/1000-$jobtime;
			$avgQueueTime+=$jobStart/1000-$jobtime;
			#print $avgQueueTime."\n";
			#print %queueTime."\n";
			#$x=$x.(($jobStop-$startTime)/1000)."\t";
			$stages{$jobname}{"stop"}=$jobStop;
			#$globaljobdetail{"stop"}{$jobname}=1;
			#$globaljobdetail{"stop"}{"stop"}=1;
			$exeTimes{$jobname}=$jobStop/1000-$jobStart/1000;
			$avgExeTime+=$jobStop/1000-$jobStart/1000;
			$realJob++;
			#print %exeTimes."\n";
			close HLOG;
		}
		else {
			next;
		}
	}
	else {
		next;
	}
}

if($haveLogFile==1){
	my $jobcounter=0;
	$throughput=($realJob)/$exeTime;
	$avgResponse=$avgResponse/($realJob);
	$avgQueueTime=$avgQueueTime/($realJob);
	$avgBlockprocess=$avgExeTime/$totalBlock;
	$avgExeTime=$avgExeTime/$realJob;
	$blockProcessTime=$exeTime/$totalBlock;
	print OUT $throughput."\t".$avgResponse."\t".($counter+1)."\t".$totalBlock."\t".$exeTime."\t ".$blockProcessTime."\n";
	foreach my $keys (sort keys(%queueTime)) {
		print OUT "JobName\t".$keys."\tQueue Time: ".$queueTime{$keys}."\tExe Time: ".$exeTimes{$keys}."\n";		
		print  "Map start at:".$stages{$keys}{"mapstart"}."\t Stop at:".$stages{$keys}{"mapstop"}."\t"."Time: ".(($stages{$keys}{"mapstop"}-$stages{$keys}{"mapstart"})/1000)."\n";
#		print OUT "Reduce-Shuffle start at:".$stages{$keys}{"shufflestart"}."\t Stop at:".$stages{$keys}{"shufflestop"}."\t"."Time: ".(($stages{$keys}{"shufflestop"}-$stages{$keys}{"reducestart"})/1000)."\n";
#		print OUT "Reduce-Sort start at:".$stages{$keys}{"shufflestop"}."\t Stop at:".$stages{$keys}{"sortstop"}."\t"."Time: ".(($stages{$keys}{"sortstop"}-$stages{$keys}{"shufflestop"})/1000)."\n";
		print  "Reduce start at:".$stages{$keys}{"redstart"}."\t Stop at:".$stages{$keys}{"redstop"}."\t"."Time: ".(($stages{$keys}{"redstop"}-$stages{$keys}{"redstart"})/1000)."\n";
		#foreach $key2 (sort keys(%tasks)) {
		#	if($key2=~m/^task_(\w+)_m/ or $key2=~m/^task_(\w+)_r/){
		#		my $getjobname=$1;
		#		if ( $getjobname eq $keys  ) {
		#			print OUT $key2."\tStart at: ".$tasks{$key2}{"start"}."\tFinish at: ".$tasks{$key2}{"stop"}."\t Process Time: ".(($tasks{$key2}{"stop"}-$tasks{$key2}{"start"})/1000)."\tAt:".$tasks{$key2}{"location"}."\n";
		#			#print OUT $key2."\tStart at: ".$tasks{$key2}{"start"}."\tFinish at: ".$tasks{$key2}{"stop"}."\t Process Time: ".(($tasks{$key2}{"stop"}-$tasks{$key2}{"start"})/1000)."\tAt:".$tasks{$key2}{"location"}."\t DataSource: ".$tasks{$key2}{"datasource"}."\n";
		#		}
		#		else {next;}
		#	}
		#}

		#output queue time and exe time for estimation. 
		$jobcounter++;
		if ($jobcounter<10) {
			$estimateKey="0".$jobcounter;
		}
		else {
			$estimateKey=$jobcounter;
		}
		$estimate{$estimateKey}{"queueTime"}=$queueTime{$keys};
		$estimate{$estimateKey}{"exeTime"}=$exeTimes{$keys};
	}
	print OUT "Average Queue Time:\t".$avgQueueTime."\n";
	print OUT "Average Exe Time:\t".$avgExeTime."\n";
	print OUT "Average Block Exe Time:\t".$avgBlockprocess."\n";
	$jobcounter=0;
	for (my $j=0;$j<@startTimes ;$j++) {
		print OUT $startTimes[$j].":".$blockNum{$startTimes[$j]}.":".$responseTime[$j].":".$blockDetails{$startTimes[$j]};
		#foreach $taskId (%tasks) {
		#		$blockProcessTime+=$tasks{$taskId}{"stop"}-$tasks{$taskId};
		#	print OUT "\t".$taskId.":\t".($tasks{$taskId}{"stop"}-$tasks{$taskId}{"start"})."\n";
		#}

		#output the block number for estimation
		if ($blockNum{$startTimes[$j]}!=0) {
			$jobcounter++;
			if ($jobcounter<10) {
				$estimateKey="0".$jobcounter;
			}
			else {
				$estimateKey=$jobcounter;
			}
			$estimate{$estimateKey}{"startTime"}=$startTimes[$j];
			$estimate{$estimateKey}{"blockNum"}=$blockNum{$startTimes[$j]};
			#print $estimate{$jobcounter}{"blockNum"}."\n";
		}
	}
	close OUT;
}
elsif($haveLogFile==0){
	#print %queueTime;
	$avgQueueTime=$avgQueueTime/$realJob;
	$avgBlockprocess=$avgExeTime/$totalBlock;
	$avgExeTime=$avgExeTime/$realJob;
	$avgResponse=$avgResponse/($realJob);
	foreach my $keys (sort keys(%queueTime)) {
		#print $keys."\n";
		#print "Job Start at:\t".$keys."\tQueue Time: ".$queueTime{$keys}."\tExe Time: ".$exeTimes{$keys}."\n";
		print OUT "JObName:\t".$keys."\tQueue Time: ".$queueTime{$keys}."\tExe Time: ".$exeTimes{$keys}."\n";
		print OUT "Map start at:".$stages{$keys}{"mapstart"}."\t Stop at:".$stages{$keys}{"mapstop"}."\t"."Time: ".(($stages{$keys}{"mapstop"}-$stages{$keys}{"mapstart"})/1000)."\n";
#		print OUT "Reduce-Shuffle start at:".$stages{$keys}{"shufflestart"}."\t Stop at:".$stages{$keys}{"shufflestop"}."\t"."Time: ".(($stages{$keys}{"shufflestop"}-$stages{$keys}{"reducestart"})/1000)."\n";
#		print OUT "Reduce-Sort start at:".$stages{$keys}{"shufflestop"}."\t Stop at:".$stages{$keys}{"sortstop"}."\t"."Time: ".(($stages{$keys}{"sortstop"}-$stages{$keys}{"shufflestop"})/1000)."\n";
		print OUT "Reduce start at:".$stages{$keys}{"redstart"}."\t Stop at:".$stages{$keys}{"redstop"}."\t"."Time: ".(($stages{$keys}{"redstop"}-$stages{$keys}{"redstart"})/1000)."\n";
		#foreach $key2 (sort keys(%tasks)) {
		#	if($key2=~m/^task_(\w+)_m/ or $key2=~m/^task_(\w+)_r/){
		#		my $getjobname=$1;
		#		if ( $getjobname eq $keys  ) {
		#		print OUT $key2."\tStart at: ".$tasks{$key2}{"start"}."\tFinish at: ".$tasks{$key2}{"stop"}."\t Process Time: ".(($tasks{$key2}{"stop"}-$tasks{$key2}{"start"})/1000)."\tAt:".$tasks{$key2}{"location"}."\n";	
		#		#print OUT $key2."\tStart at: ".$tasks{$key2}{"start"}."\tFinish at: ".$tasks{$key2}{"stop"}."\t Process Time: ".(($tasks{$key2}{"stop"}-$tasks{$key2}{"start"})/1000)."\tAt:".$tasks{$key2}{"location"}."\t DataSource: ".$tasks{$key2}{"datasource"}."\n";
		#		}
		#		else {next;}
		#	}
		#}
	}	
	print OUT "Average Queue Time:\t".$avgQueueTime."\n";
	print OUT "Average Exe Time:\t".$avgExeTime."\n";
	print OUT "Average Block Exe Time:\t".$avgBlockprocess."\n";
	for (my $j=0;$j<@startTimes ;$j++) {
		print OUT $startTimes[$j].":".$responseTime[$j]."\n";
		#foreach $taskId (%tasks) {
		#	$blockProcessTime+=$tasks{$taskId}{"stop"}-$tasks{$taskId};
		#	print OUT "\t".$taskId.":\t".($tasks{$taskId}{"stop"}-$tasks{$taskId}{"start"})."\n";
		#}
	}
	close OUT;
}

#estimate process 
open(STA,">>../statistics.txt")||die "Can not open statistics file";
$pwd=`pwd`;
if($pwd=~m/10-(\S+)$/){
	$pwd=$1;
}
#print $pwd."\n";
my @xvalue;
my @yvalue;
my @y1value;
my @y3value;
my @lysGraph;
my @lysX;
my @lysX1;
my @lysY;
my @lysY1;

my $y="";
#push(@lysY1,0);
$jobcounter=0;
my $queueTillNow=-1;
foreach $keys (sort keys(%estimate)) {
	$queueTillNow+=$estimate{$keys}{"queueTime"};
	if ($keys==1) {
		$jobstart=$estimate{$keys}{"startTime"};
		$previousExeTime+=$estimate{$keys}{"exeTime"};
		$previousBlockNum+=$estimate{$keys}{"blockNum"};
		$estimateBlockExeTime=$previousExeTime/$previousBlockNum;
		#$estimateResponse=$estimate{$keys}{"queueTime"}+$estimateBlockExeTime*$estimate{$keys}{"blockNum"};
		$estimateResponse=$queueTillNow/$keys+$previousExeTime/$keys;
		$y3value[$jobcounter]=$estimate{$keys}{"queueTime"};
	}
	else{
		$estimateBlockExeTime=$previousExeTime/$previousBlockNum;
#		$estimateResponse=$estimate{$keys}{"queueTime"}+$estimateBlockExeTime*$estimate{$keys}{"blockNum"};
		$y3value[$jobcounter]=$queueTillNow/$keys+$previousExeTime/($keys-1);
		$previousExeTime+=$estimate{$keys}{"exeTime"};
		$estimateResponse=$queueTillNow/$keys+$previousExeTime/$keys;
		$previousBlockNum+=$estimate{$keys}{"blockNum"};
	}
	$xvalue[$jobcounter]=($estimate{$keys}{"startTime"}-$jobstart)/1000;
	#$x=$x.$xvalue[$jobcounter]."\t";
	#$xvalue[$jobcounter]=$keys;
	$yvalue[$jobcounter]=$estimateResponse;
	#$y=$y.$estimateResponse."\t";
	print "Actual Response:".$estimateResponse."\n";
        #$match{$xvalue[$jobcounter]}=$y;
	$y1value[$jobcounter]=$estimate{$keys}{"queueTime"}+$estimate{$keys}{"exeTime"};
	$y2value[$jobcounter]=$estimate{$keys}{"blockNum"};
	push(@lysY,$y3value[$jobcounter]);
	push(@lysY1,$yvalue[$jobcounter]);
	#$y3value[$jobcounter]=$queueTillNow/$keys+$estimateBlockExeTime*$estimate{$keys}{"blockNum"};
	#print $estimate{$keys}{"startTime"}."\t".$jobstart."\t".$keys."\n";
	print STA $keys."\n";
	print STA $xvalue[$jobcounter]."\t$estimateResponse\t".($estimate{$keys}{"queueTime"}+$estimate{$keys}{"exeTime"})."\n";
	$jobcounter++;
}
my %output;
my $jobdequeue=0;
my $jobfinish=0;
my $queueTimetillnow=0;
my $exeTimetillnow=0;
my $eResponse=0;
my $linex="";
my $liney="";
open(LY,">lysdata.txt")||die "Can not dump data";
print LY "---------------------------------\n";
foreach my $lykeys (sort keys %stages) {
	push(@lysX,$stages{$lykeys}{"mapstart"});
	push(@lysX1,$stages{$lykeys}{"stop"});
	#print $stages{$lykeys}{"mapstart"}-$startTime."\n";
	#print $lysX1[@lysX1]."\n";
	#print $stages{$lykeys}{"stop"}-$startTime."\n";
}

for (my $num=0;$num<@lysX;$num++) {
	$output{$lysX[$num]}=$lysY[$num];
	$output{$lysX1[$num]}=$lysY1[$num];
	$output2{$lysX1[$num]}=$lysY1[$num];
	#print $lysX1[$num]."\n";
}
$x="";
my $medy="";
foreach my $outkey (sort keys %output2) {
	$exeTimetillnow=0;
	$queueTimetillnow=0;
	$jobfinish=0;
	$x=$x.(($outkey-$startTime)/1000)."\t";
	#print $x."\n";
	foreach my $firstkey (sort keys %stages) {
		#if ($stages{$firstkey}{"mapstart"}<=$outkey) {
		#	$jobdequeue++;
		#	$queueTimetillnow+=$queueTime{$firstkey};
		#}
		if($stages{$firstkey}{"stop"}<=$outkey){
			$jobfinish++;
			$exeTimetillnow+=$exeTimes{$firstkey};
			$queueTimetillnow+=$queueTime{$firstkey};
					print "1:JobID:".$firstkey."StopTime:".$stages{$firstkey}{"stop"}."rule:".$outkey."QT:".$queueTime{$firstkey}."\n";
		}
	}
	if ($jobfinish==0) {
		$eResponse=undef;
	}
	else {
		print "1:Time:".$outkey."QueueTime:".($queueTimetillnow/$jobfinish)."Exetime:".($exeTimetillnow/$jobfinish)."\n";
		$eResponse=$queueTimetillnow/$jobfinish+$exeTimetillnow/$jobfinish;
	}
	#print $y."\n";
	$output2{$outkey}=$eResponse;
	print "This is the eResponse-1:".$eResponse."\n";
	$y=$y.$eResponse."\t";
}
foreach my $lykeys (sort keys %output){
	push(@xax, ($lykeys-$startTime)/1000);
	$linex=$linex.(($lykeys-$startTime)/1000)."\t"; 
	$queueTimetillnow=0;
	$exeTimetillnow=0;
	$jobdequeue=0;
	$jobfinish=0;
	foreach my $secondkey (sort keys %stages) {
		if ($stages{$secondkey}{"mapstart"}<=$lykeys) {
			$jobdequeue++;
			$queueTimetillnow+=$queueTime{$secondkey};
		}
		if($stages{$secondkey}{"stop"}<=$lykeys){
			$jobfinish++;
			$exeTimetillnow+=$exeTimes{$secondkey};

		}
	}
	if ($jobfinish==0) {
		$eResponse=$queueTimetillnow/$jobdequeue;
	}
	else {
		print "2:QueueTime:".($queueTimetillnow/$jobfinish)."Exetime:".($exeTimetillnow/$jobfinish)."\n";
		$eResponse=$queueTimetillnow/$jobdequeue+$exeTimetillnow/$jobfinish;
	}
	$liney=$liney.$eResponse."\t";
	print "This is the eResponse-2:".$eResponse."\n";
	push(@medy,$eResponse);
}

#generate perl graph by GD, failed
$i=0;
$j=0;
my @finaly;
foreach $i (sort @lysX1){
#while($i<@lysX1){
    while($j<@xax){
	#print $xax[$j]."\t".(($i-$startTime)/1000)."\n";
	#print $j."\t".(($lysX1[$i]-$startTime)/1000)."\n";
	#if((($i-$startTime)/1000)==$xax[$j]){
	if((($i-$startTime)/1000)==$xax[$j]){
	     #print $output2{$lysX1[$i]}."\n";
	     # print $output2{$i}."\n";
	    # push(@finaly,$output2{$lysX1[$i]});
	      push(@finaly,$output2{$i});
	     $j++; 
	     last;  
	}
	else {
	    push(@finaly,undef);
	}
	$j++;
    }
    $i++;
}
########################################
print LY $linex."\n";
print LY $liney."\n";
print LY $x."\n";
print LY $y."\n";
print LY "---------------------------------\n";
close LY;
#foreach my $lykeys (sort {$output{$a}<=>$output{$b}} keys %output) {
#	push(@yax, $output{$lykeys})
#}


############
#
#Dr.Lu's requirement graph
#
############

push(@lysGraph,\@xax);
push(@lysGraph,\@medy);
push(@lysGraph,\@finaly);
my $ly_graph=GD::Graph::linespoints->new(800,600);
$ly_graph->set(
x_label => 'Simulation job arrive time', 
y_label => 'Average Response Time / Second', 
title => $estimateTitle, 
#y_max_value => 80, 
y_tick_number => 6, 
y_label_skip => 2, 
markers => [ 1, 5 ], 
y_long_ticks => 1,
transparent => 0,
);
$ly_graph->set_legend( 'ResponseTime Value'); 
open(IMG5,">../$pwd.lys.png");
$ly_graph->plot(\@lysGraph) or return 0;
print IMG5 $ly_graph->gd->png;
close IMG5;


close STA;
open (PA,"parameters.txt")|| die "Can not open parameter file";
$estimateTitle=<PA>;
close PA;
my @blockseq;
#generate corresponding graphs
push(@data2plot,\@xvalue);
push(@data2plot,\@yvalue);
push(@data2plot,\@y1value);

push(@blockseq,\@xvalue);
push(@blockseq,\@y2value);

my $my_graph = GD::Graph::linespoints->new(800,600); 
my $my_graph1 = GD::Graph::linespoints->new(800,600);
$my_graph->set( 
x_label => 'Simulation job arrive time', 
y_label => 'Response Time / Second', 
title => $estimateTitle, 
#y_max_value => 80, 
y_tick_number => 6, 
y_label_skip => 2, 
markers => [ 1, 5 ], 
y_long_ticks => 1,
transparent => 0, 
); 

#general graph for each run with many jobs
$my_graph1->set( 
x_label => 'Simulation job arrive time', 
y_label => 'No. of Blocks', 
title => $estimateTitle, 
#y_max_value => 80, 
y_tick_number => 6, 
y_label_skip => 2, 
markers => [ 1, 5 ], 
y_long_ticks => 1,
transparent => 0, 
); 


$my_graph->set_legend( 'Estimated Value', 'Actual Value' ); 
#$my_graph1->set_legend( 'Estimated Value', 'Actual Value' );
open(IMG,">../$pwd.png");
open(IMG1,">./$pwd.png");
open(IMG3,">../$pwd.block.png");
open(IMG4,">./$pwd.block.png");

#$graph_nodeview->set(show_values => 1);
$my_graph->plot(\@data2plot) or return 0;
$my_graph1->plot(\@blockseq) or return 0;
print IMG $my_graph->gd->png;
print IMG1 $my_graph->gd->png;
close IMG;
close IMG1;

print IMG3 $my_graph1->gd->png;
print IMG4 $my_graph1->gd->png;
close IMG3;
close IMG4;

#dump data for the expedted response time 
open (EXP,">>../expectedResponse.txt");
print EXP $avgResponse."\t".($avgQueueTime+$exeTime/($jobcounter+1))."\t".$totalBlock."\n";
close EXP;
 
#process directory
sub ProcessDir{
	my $path=shift;
	#print $path."\n";
	opendir(RRDIR,$path)|| die "Can not open the rrd directory!";
	my @my_file=readdir(RRDIR);
	#print @my_file."\n";
	for (my $count=0;$count<@my_file;$count++) {
		if (-d ($path."\/".$my_file[$count])) {
			if ($my_file[$count]=~m/^\./ ) {
				if ($my_file[$count]=~m/^\.\.?$/) {
					next;
				}
			}
			#print $my_file[$count]."\n";
			my $subdir=$path."\/".$my_file[$count];
			&PushDir($subdir);
		}
		else{
			#print $path."\/".$my_file[$count]."\n";
			if($my_file[$count]=~m/(\w+)\.rrd$/g) {
				#print $1."\n";
				$filename=$1;
				$path=~m/\/(\w+)$/;
				$subdirname=$1;
				if ($subdirname eq $filename){
				$subdirname='head_';}
				#print $subdirname."\n";
				&EachRrdPlot($startTime/1000,$stopTime,$path);
			}
		}
	}
	closedir(RRDIR);
	my $sub_dir=&PopDir();
	#print $sub_dir."\n";
	if ( -e $sub_dir) {
		&ProcessDir($sub_dir);
	}
}
sub PushDir{
	my $path_fs = shift;
    push (@stack, $path_fs);
}
sub PopDir(){
	my $size = @stack;
    if($size != 0)
    {
    	my $buf_pop = pop(@stack);
        return $buf_pop;    
    }
	else {
		return 0;
	} 
}
###################################3


#subroutine to generate the graph from rrd file!


###################################3

sub EachRrdPlot{

    my ($start_time,$end_time,$rrdPath)=@_;
    $start_time=split("\.",$start_time);
	print "Information from Outside:".$start_time."\t".$end_time."\t".$rrdPath."\n";
	my $cur_time = time();                # set current time
	if($end_time<0 and $start_time>0)
	{
		$end_time = $start_time+86400;     
		#$start_time = $end_time - 86400;
	}
	elsif ($end_time>0 and $start_time<0){
		$start_time=$end_time-86400;
	}
	elsif($end_time<0 and $start_time<0){
		$end_time=$cur_time;
		$start_time=$end_time-86400;
	}
	#print $start_time."\t".$end_time."\n";
	my $rrdfile=$rrdPath."\/".$filename.".rrd";

	# fetch average values from the RRD database between start and end time
	#my ($start,$step,$ds_names,$data) =
    #RRDs::fetch("$rrdfile", "AVERAGE","-s", "$start_time", "-e", "$end_time");
        #my $what=RRDs::fetch("$rrdfile", "AVERAGE","-s", "$start_time", "-e", "$end_time"); 
	#print ."\n";
	#foreach $ke (@$data) {
	#	foreach $kd ($ke) {
	#					print $kd."\n";
	#	}
	#}

	# save fetched values in a 2-dimensional array
	#my $rows = 0;
	#my $columns = 0;
	#my $time_variable = $start;
	#foreach $line (@$data) {
	#	$vals[$rows][$columns] = $time_variable;
	#	$time_variable = $time_variable + $step;
	#	foreach $val (@$line) {
         #  $vals[$rows][++$columns] = $val;}
	#		$rows++;
	#		$columns = 0;
	#	}
	#	my $tot_time = 0;
	#	my $count = 0;
		# save the values from the 2-dimensional into a 1-dimensional array

		my $pngfile=$subdirname.$filename;
		#print $pngfile."\n";
		my $metricName=$filename;
		#my $curdir=`pwd`;
		#chomp($curdir);
		#$curdir=$curdir."\/Status\/$pngfile.png";
		#print $rrdfile."\n";
		# create the graph
		#print `ls $rrdfile`;
		#print `ls $metricName`;
		#print `ls ./Status/$pngfile.png`;
		RRDs::graph ("./Status/$pngfile.png",   
             "--title= $metricName",     
             "--start=$start_time",      
             "--end=$end_time",          
             "--color=BACK#CCCCCC",      
             "--color=CANVAS#CCFFFF",    
             "--color=SHADEB#9999CC",    
             "--height=300",                    
             "--rigid",                  
             "DEF:tot_=$rrdfile:sum:AVERAGE", 
             "LINE2:tot_#FF0000",
	     #"CDEF:result=PREV(tot_)",
	     "COMMENT:Graph is rendered between $start_time",
             "COMMENT:    and $end_time ");
		#print `ls $curdir`;
	    my $err=RRDs::error;
	    if ($err) {print "problem generating the graph: $err\n";}
 }



 #sub insertSort{	
#	if ($counter==1) {
#			$startTimes[$counter]=$incomingData;
#		}
#		else{
#			my $length=@startTimes;
#			for (my $i=0;$i<@startTimes;$i++) {
#				if ($incomingData lt $startTimes[1]) {
#					for (my $j=@startTimes;$j>0;$j--) {
#						$startTime[$j]=$startTimes[$j+1];
#					}
					#$incomingData=$incomingData+$startTimes[$i+1];
					#$startTimes[$i+1]=$incomingData-$startTimes[$i+1];
					#$incomingData=$incomingData-$startTimes[$i+1];					
#				}
#				elsif($incomingData gt $startTimes[$length]){
#					$startTimes[$length+1]=$incomingData;
#				}
#				else{
#				}
#			}
#		}
#}
