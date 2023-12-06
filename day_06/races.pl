#!/usr/bin/env perl

use strict;
use warnings;
use POSIX qw(ceil floor);

open my $fh, '<', 'input.txt' or die;
local $/ = undef;
our $contents = <$fh>;
close $fh;

our @races = preprocess($contents);

sub preprocess {
  my $input = shift;
  my @matches = ($input =~ m/\d+/g);
  my @output;
  for (my $i = 0; $i <= int($#matches / 2); $i++) {
    push @output, [$matches[$i], $matches[$i + @matches / 2]];
  }
  return @output;
}

=pod

Given a race length C<t> and a record distance C<d>, we can calculate the
possibilities using the charging time C<x> and the running time C<y> as
follows:

    x * y >= d
    x + y = t -> y = t - x

    x * (t - x) >= d -> xt - x^2 >= d -> 0 >= x^2 - xt + d

=cut
sub task1 {
  my $product = 1;
  for my $race (@races) {
    $product *= _get_amounts_of_winning_options($race);
  }
  print "The product of all number of possibilities is $product!\n";
}

sub task2 {
  my $super_race = ["", ""];
  for my $race (@races) {
    $super_race->[0] .= $race->[0];
    $super_race->[1] .= $race->[1];
  }
  my $options = _get_amounts_of_winning_options($super_race);
  print "For the super race the amount of options is $options!\n";
}

sub _get_amounts_of_winning_options {
  my $race = shift;
  my ($lower, $upper) = _get_race_bounds($race);
  return floor($upper) - ceil($lower) + 1;
}

sub _get_race_bounds {
  my $race = shift;
  my $t = $race->[0];
  my $d = $race->[1];
  my $root_term = sqrt($t**2 - 4 * 1 * $d);
  return (($t - $root_term) / 2, ($t + $root_term) / 2);
}

task1();
task2();
