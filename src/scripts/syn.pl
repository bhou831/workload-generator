#!/bin/perl -w

opendir(DIR,".")||die "";
@array=readdir(DIR);
for (my $i=0;$i<@array;$i++){
    if (-d $array[$i]){
	`cp getProcessMetrics.pl $array[$i]`;
    }
}
close DIR;
