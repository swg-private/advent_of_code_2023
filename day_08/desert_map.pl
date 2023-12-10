#!/usr/bin/env perl

use strict;
use warnings;

open my $fh, '<', 'input.txt' or die;
local $/ = undef;
our $contents = <$fh>;
close $fh;

our @moves;
our %map;

sub preprocess {
  my $input = shift;
  my ($moves, $map) = split "\n\n", $input, 2;
  @moves = split //, $moves;
  foreach my $map_entry (split "\n", $map) {
    my @matches = ($map_entry =~ m/(\w{3})/g);
    $map{$matches[0]} = [$matches[1], $matches[2]];
  }
}

sub task1 {
  my $num_of_steps = 0;
  my $node = "AAA"; # starting node
  while ($node ne "ZZZ") {
    my $step = $moves[$num_of_steps % @moves];
    $node = ($step eq "L" ? $map{$node}->[0] : $map{$node}->[1]);
    $num_of_steps++;
  }
  print "The total number of steps is $num_of_steps!\n";
}

preprocess($contents);
task1();
