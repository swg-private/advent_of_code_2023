#!/usr/bin/env perl

use strict;
use warnings;
use List::Util qw(notall);

open my $fh, '<', 'input.txt' or die;
local $/ = undef;
our $contents = <$fh>;
close $fh;

my @sequences = preprocess($contents);

sub preprocess {
  my $input = shift;
  my @output;
  foreach my $sequence (split "\n", $input) {
    push @output, [split " ", $sequence];
  }
  return @output;
}

sub task1 {
  my $sum_of_predictions = 0;
  foreach my $sequence (@sequences) {
    my @sequence_differences = ($sequence);
    my $last_sequence = $sequence_differences[$#sequence_differences];
    do {
      my @difference;
      for (my $i = 0; $i < $#{$last_sequence}; $i++) {
        push @difference, ($last_sequence->[$i + 1] - $last_sequence->[$i]);
      }
      push @sequence_differences, \@difference;
      $last_sequence = $sequence_differences[$#sequence_differences];
    } while (notall { $_ == 0 } @{$last_sequence});
    my $sum = 0;
    foreach my $seq (@sequence_differences) {
      $sum += $seq->[$#{$seq}];
    }
    $sum_of_predictions += $sum;
  }
  print "Total of all predictions is $sum_of_predictions!\n";
}

task1();
