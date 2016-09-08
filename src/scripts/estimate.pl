#!/usr/bin/perl -w

use strict;
use warnings;

my 


foreach $parameter (@ARGV){
    my $resultfile=$parameter."\/"."results.txt";
    `rm $resultfile/`;
    `perl getProcessMetrics.pl finishTime* log.txt /home/hadoopLog/*`;
    open(RES,"$resultfile")||die "can not open the result file";
    open(STA,">>statistic.txt")||die "Can not open the statistic file";
    while(<RES>){
	my $line=$_;
	if($line=~m/^JobName (\w+)/){
	}
    }	
}
