#!/usr/bin/env perl

use strict;
use warnings;
use List::Util qw(any all);
use Data::Dumper;

open my $fh, '<', 'input.txt' or die;
local $/ = undef;
our $contents = <$fh>;
close $fh;

our $grid = preprocess($contents);
our %connections = (
  "." => [],
  "|" => [[0, -1], [0, 1]],
  "-" => [[1, 0], [-1, 0]],
  "L" => [[0, -1], [1, 0]],
  "J" => [[0, -1], [-1, 0]],
  "7" => [[0, 1], [-1, 0]],
  "F" => [[0, 1], [1, 0]],
);

sub preprocess {
  my $input = shift;
  my $output = [];
  foreach my $line (split "\n", $input) {
    push @{$output}, [ split //, $line ];
  }
  return $output;
}

=pod

Solution assuming the start is well-defined, and doesn't connect
to dead-ends in addition to the main loop.

=cut
sub task1 {
  my ($xs, $ys) = _get_start_coordinates();
  my $type_s = _get_start_tile_type($xs, $ys);
  print "$type_s\n";
}

sub _get_start_coordinates {
  for (my $y = 0; $y <= $#{$grid}; $y++) {
    for (my $x = 0; $x <= $#{$grid->[0]}; $x++) {
      return ($x, $y) if $grid->[$y]->[$x] eq "S";
    }
  }
}

=pod

Assuming the start tile is not on the edge (because it isn't).

=cut
sub _get_start_tile_type {
  my ($x, $y) = @_;
  my @neighbours = ([0, 1], [0, -1], [1, 0], [-1, 0]);
  my @connections;
  foreach my $neighbour (@neighbours) {
    my $element = $grid->[$y - $neighbour->[1]]->[$x - $neighbour->[0]];
    push @connections, $neighbour if any { _is_equal_vector($neighbour, $_) } @{$connections{$element}};
  }
  while (my ($tile_type, $connections) = each %connections) {
    next if $tile_type eq "."; # not interesting or possible
    my $match = 1;
    for (my $i = 0; $i <= $#connections; $i++) {
      if (!_is_reversed_vector($connections->[$i], $connections[$i])) {
        $match = 0;
      }
    }
    return $tile_type if $match;
  }
}

sub _is_equal_vector {
  my ($a, $b) = @_;
  return _compare_vector($a, $b, 1);
}

sub _is_reversed_vector {
  my ($a, $b) = @_;
  return _compare_vector($a, $b, -1);
}

sub _compare_vector {
  my ($a, $b, $reverse) = @_;
  for (my $i = 0; $i <= $#{$a}; $i++) {
    return 0 if $a->[$i] != $reverse * $b->[$i];
  }
  return 1;
}

task1();
