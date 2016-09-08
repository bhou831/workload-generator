#!/usr/bin/perl -w
# This is a program made by chen he. It is used for sum the number of nodes during the workload execution
#
#eg: perl summationNodes.pl [input file] [start time] [stop time]
#
#start time is like 2012-4-12-14-24-3
#

#use strict;
#use warnings;
use Time::Local;
use GD::Graph::lines;


open(IN, "$ARGV[0]")||die "can not open file";
my $line;
my $t;
my $number;
my $start=$ARGV[1];
my $end=$ARGV[2];
my $area=0;
my $my_graph=GD::Graph::lines->new(800,600);
my $data;
my @x;
my @y;
my $counter=0;

#deal with the incomplete condition
if($start eq "" or $end eq ""){
    $start=0;
    $end=0;
}

#change normal time to unix time
my ($year,$mon,$day,$hour,$min,$sec)=split("-",$start);
#print $start."\n";
$start=timelocal($sec,$min,$hour,$day,($mon-1),$year);
#print scalar localtime $start."\n";


($year,$mon,$day,$hour,$min,$sec)=split("-",$end);
$end=timelocal($sec,$min,$hour,$day,($mon-1),$year);
#print $end."\n";

while(<IN>){
    $counter++;
    $line=$_;
    #print $line;
    chomp($line);
    ($t,$number)=split(":",$line);
    if($t le $end and $t ge $start){
        $area+=$number;
        push(@x,$counter*5);
        push(@y,$number);    
    }
}
$area*=5;
print $area."\n";

push(@data,\@x);
push(@data,\@y);
$my_graph->set(
    x_label =>'Execution time of Workload',
    y_label =>'Number of available Nodes',
    title=>'Available Node of HOG',
    transparent=>0,
);
open(IMG,">ARGV[0].png")||die "Can not open file";
$my_graph->plot(\@data) or return 0;
print IMG $my_graph->gd->png;
close IMG;
