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
			$exeTimes{$jobname}=$jobStop/1000-$jobStart/1000;
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
	$throughput=($counter+1)/$exeTime;
	$avgResponse=$avgResponse/($counter+1);
	$avgQueueTime=$avgQueueTime/($counter+1);
	$blockProcessTime=$exeTime/($counter+1);
	print OUT $throughput."\t".$avgResponse."\t".($counter+1)."\t".$totalBlock."\t".$exeTime."\t".$blockProcessTime."\n";
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
	}
	print OUT "Average Queue Time:\t".$avgQueueTime."\n";
	
	for (my $j=0;$j<@startTimes ;$j++) {
		print OUT $startTimes[$j].":".$blockNum{$startTimes[$j]}.":".$responseTime[$j].":".$blockDetails{$startTimes[$j]};
		#foreach $taskId (%tasks) {
		#		$blockProcessTime+=$tasks{$taskId}{"stop"}-$tasks{$taskId};
		#	print OUT "\t".$taskId.":\t".($tasks{$taskId}{"stop"}-$tasks{$taskId}{"start"})."\n";
		#}
	}
	close OUT;
}
elsif($haveLogFile==0){
	#print %queueTime;
	$avgQueueTime=$avgQueueTime/($counter+1);
	foreach my $keys (sort keys(%queueTime)) {
		#print $keys."\n";
		#print "Job Start at:\t".$keys."\tQueue Time: ".$queueTime{$keys}."\tExe Time: ".$exeTimes{$keys}."\n";
		print OUT "JObName:\t".$keys."\tQueue Time: ".$queueTime{$keys}."\tExe Time: ".$exeTimes{$keys}."\n";
		print OUT "Map start at:".$stages{$keys}{"mapstart"}."\t Stop at:".$stages{$keys}{"mapstop"}."\t"."Time: ".(($stages{$keys}{"mapstop"}-$stages{$keys}{"mapstart"})/1000)."\n";
#		print OUT "Reduce-Shuffle start at:".$stages{$keys}{"shufflestart"}."\t Stop at:".$stages{$keys}{"shufflestop"}."\t"."Time: ".(($stages{$keys}{"shufflestop"}-$stages{$keys}{"reducestart"})/1000)."\n";
#		print OUT "Reduce-Sort start at:".$stages{$keys}{"shufflestop"}."\t Stop at:".$stages{$keys}{"sortstop"}."\t"."Time: ".(($stages{$keys}{"sortstop"}-$stages{$keys}{"shufflestop"})/1000)."\n";
		print OUT "Reduce start at:".$stages{$keys}{"redstart"}."\t Stop at:".$stages{$keys}{"redstop"}."\t"."Time: ".(($stages{$keys}{"redstop"}-$stages{$keys}{"redstart"})/1000)."\n";
		foreach $key2 (sort keys(%tasks)) {
			if($key2=~m/^task_(\w+)_m/ or $key2=~m/^task_(\w+)_r/){
				my $getjobname=$1;
				if ( $getjobname eq $keys  ) {
		#		print OUT $key2."\tStart at: ".$tasks{$key2}{"start"}."\tFinish at: ".$tasks{$key2}{"stop"}."\t Process Time: ".(($tasks{$key2}{"stop"}-$tasks{$key2}{"start"})/1000)."\tAt:".$tasks{$key2}{"location"}."\n";	
				print OUT $key2."\tStart at: ".$tasks{$key2}{"start"}."\tFinish at: ".$tasks{$key2}{"stop"}."\t Process Time: ".(($tasks{$key2}{"stop"}-$tasks{$key2}{"start"})/1000)."\tAt:".$tasks{$key2}{"location"}."\t DataSource: ".$tasks{$key2}{"datasource"}."\n";
				}
				else {next;}
			}
		}
	}	
	print OUT "Average Queue Time:\t".$avgQueueTime."\n";
		
	for (my $j=0;$j<@startTimes ;$j++) {
		print OUT $startTimes[$j].":".$responseTime[$j]."\n";
		#foreach $taskId (%tasks) {
		#	$blockProcessTime+=$tasks{$taskId}{"stop"}-$tasks{$taskId};
		#	print OUT "\t".$taskId.":\t".($tasks{$taskId}{"stop"}-$tasks{$taskId}{"start"})."\n";
		#}
	}
	close OUT;
}

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
