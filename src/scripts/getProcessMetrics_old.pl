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

open(OUT,">>results.txt")||die "Can not open result file";

foreach $parameter (@ARGV) {

	if($parameter=~m/^finishTime_(\d+)\.txt/){
		$counter++;
		#print $1."\n";
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
for (my $i=0;$i<@startTimes;$i++){
	$responseTime[$i]=$stopTimes[$i]-$startTimes[$i];
	$avgResponse+=$responseTime[$i];
}

#print @jobs;
foreach my $j (@jobs) {
	$jobStart=9999999999999;
	$jobStop=-1;
	#print $j;
	if($j=~m/_che_wordcount(\d+)/){
	$jobname=$1/1000;
	$jobtime=$1/1000;
		#print $jobname."\n";
		#print ($jobtime/1000)."\t".$startTime."\t".$stopTime."\n";
		if ($jobtime > $startTime and $jobtime < $stopTime) {
			#print $jobtime."\t".$startTime."\t".$stopTime."\t".$j."\n";
			open(HLOG,"$j")||die "Can not open hadoop log file";
			my @array=<HLOG>;
			for(my $k=0;$k<@array;$k++){
				my $line=$array[$k];
				#print $line."\n";
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
					}
					elsif($line=~m/FINISH_TIME=\"(\d+)\"/){
						$tasks{$taskId}{"stop"}=$1;
						if($jobStop < $tasks{$taskId}{"stop"}){
							$jobStop = $tasks{$taskId}{"stop"};
							#print $jobStop."jobstop\n";
						}
					}
				}
			}
			#print $jobname."jobname\n";
			$queueTime{$jobname}=$jobStart/1000-$jobtime;
			$avgQueueTime+=$jobStart/1000-$jobtime;
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
		print OUT "\t".$keys."\tQueue Time: ".$queueTime{$keys}."\tExe Time: ".$exeTimes{$keys}."\n";
	}
	foreach $keys (keys(%tasks)) {
		print OUT $keys."\tStart at: ".$tasks{$keys}{"start"}."\tFinish at: ".$tasks{"start"}{"stop"}."\t Process Time: ".($tasks{"start"}{"stop"}-$tasks{$keys}{"start"})."\n";
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
	foreach my $keys (sort keys(%queueTime)) {
		#print $keys."\n";
		#print "Job Start at:\t".$keys."\tQueue Time: ".$queueTime{$keys}."\tExe Time: ".$exeTimes{$keys}."\n";
		print OUT "Job Start at:\t".$keys."\tQueue Time: ".$queueTime{$keys}."\tExe Time: ".$exeTimes{$keys}."\n";
	}
	foreach $keys (keys(%tasks)) {
		print OUT $keys."\tStart at: ".$tasks{$keys}{"start"}."\tFinish at: ".$tasks{"start"}{"stop"}."\t Process Time: ".($tasks{"start"}{"stop"}-$tasks{$keys}{"start"})."\n";
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
	my $path=@_;
	#print $path."\n";
	opendir(RRDIR,$path)|| die "Can not open the rrd directory!";
	my @my_file=readdir(RRDIR);
	print @my_file."\n";
	for (my $count=0;$count<@my_file;$count++) {
		if (-d $my_file[$count]) {
			if ($my_file[$count]=~m/^\./ ) {
				if ($my_file[$count]=~m/^\.\.?$/) {
					next;
				}
			}
			my $subdir=$path."\/".$my_file[$count];
			&PushDir($subdir);
		}
		elsif ($my_file[$count]=~m/\/(\w+)\/(\w+)\.rrd/) {
			$subdirname=1;
			$filename=$2;
			&EachRrdplot($jobStart,$jobStop,$path,2);
		}
	}
	closedir(RRDIR);
	my $sub_dir=&PopDir();
	if ( -e $sub_dir) {
		&ProcessDir($sub_dir);
	}
     die "Program Done!";
}
sub PushDirs{
	my $path_fs = shift;
   	#my $path_fs = join(//, @dir_fs);
    push (@stack, $path_fs);
}
sub Popdir(){
	my $size = @stack;
    if($size != 0)
    {
    	my $buf_pop = pop(@stack);
        return $buf_pop;    
    }
	else{
	    return 0;
	}    
}
###################################3


#subroutine to generate the graph from rrd file!


###################################3

sub EachRrdPlot{

    my ($start_time,$end_time,$rrdPath,$r)=@_;
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
	else($end_time<0 and $start_time<0){
		$end_time=$cur_time;
		$start_time=$end_time-86400;
	}
	if($r<0){
		$r=5760;
	}

	#get the information from filename
	if($rrdPath=~m/\/(\w+)\.rrd$/){
		$filename=$1;
	}

	# fetch average values from the RRD database between start and end time
	my ($start,$step,$ds_names,$data) =
    RRDs::fetch("$rrdPath", "AVERAGE",
                 "-r", "$r", "-s", "$start_time", "-e", "$end_time");
	# save fetched values in a 2-dimensional array
	my $rows = 0;
	my $columns = 0;
	my $time_variable = $start;
	foreach $line (@$data) {
		$vals[$rows][$columns] = $time_variable;
		$time_variable = $time_variable + $step;
		foreach $val (@$line) {
           $vals[$rows][++$columns] = $val;}
			$rows++;
			$columns = 0;
		}
		my $tot_time = 0;
		my $count = 0;
		# save the values from the 2-dimensional into a 1-dimensional array

		my $pngfile=$subdirname.$filename.".png";
		my $matricName=$filename;
		# create the graph
		RRDs::graph ("./Status/$pngfile",   
             "--title= $metricName",     
             "--start=$start_time",      
             "--end=$end_time",          
             "--color=BACK#CCCCCC",      
             "--color=CANVAS#CCFFFF",    
             "--color=SHADEB#9999CC",    
             "--height=600",             
             "--upper-limit=800",        
             "--lower-limit=0",          
             "--rigid",                  
#             "--base=1024",              
             #"DEF:tot_mem=$metricName:mem:AVERAGE", 
             #"CDEF:tot_mem_cor=tot_mem,0,671744,LIMIT,UN,0,tot_mem,IF,1024,/",
             #"CDEF:machine_mem=tot_mem,656,+,tot_mem,-",
             "COMMENT:Graph is rendered between $start_time",
             "COMMENT:    and $end_time ",
#             "HRULE:656#000000:Maximum Available Memory - 656 MB",
#             "AREA:machine_mem#CCFFFF:Memory Unused",   
#             "AREA:tot_mem_cor#6699CC:Total memory consumed in MB"
			);
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