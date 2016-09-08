#!/usr/bin/perl -w
my $parameter;
my $finishfile;
my $logfile;
my $perlfile;
my $pwd;
foreach $parameter (@ARGV){
    if(-d $parameter and $parameter=~m/10-10/){
	#$finishfile=$parameter."/finishTime*";
	$pwd=`pwd`;
	print $parameter."\t"."\n";
	#$pwd=split(" ",$pwd);
	#$pwd="\.\/".$parameter;
	#$logfile=$parameter."/log.txt";
	#$perlfile=$parameter."/getProcessMetrics.pl";
	#print $pwd."\t"."\n";
	`cp getProcessMetrics.pl $parameter`;
        chdir($parameter);
	`perl getProcessMetrics.pl finishTime* log.txt /home/hadoopLog/*`;
	
	chdir("/home/che/powerMan/");
	print `pwd`;
    }
    else {
	next;
    }
}
