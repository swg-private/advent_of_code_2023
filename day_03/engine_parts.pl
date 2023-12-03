#!/usr/bin/env perl

use strict;
use warnings;

open my $fh, '<', 'input.txt' or die;
local $/ = undef;
our $contents = <$fh>;
close $fh;

our $data_string = $contents;
$data_string =~ s/\n//g;
our @data_grid = map { [ split //, $_ ] } split "\n", $contents;
our $grid_width = @{$data_grid[0]};
our $grid_height = @data_grid;

=pod

Implementation assumes that there are no numbers at the end of one line,
and directly at the start of the next.

=cut
sub task1 {
  my @matches = _get_all_matches_including_indices(qr/(\d+)/);
  my $sum = 0;
  foreach my $match (@matches) {
    $sum += $match->[0] + 0 if _does_match_border_symbol($match);
  }
  print "The sum of all part numbers is $sum!\n";
}

sub task2 {

}

sub _get_all_matches_including_indices {
  my $pattern = shift;
  my @matches;
  while ($data_string =~ m/$pattern/g) {
    push @matches, [$1, $-[1], $+[1] - 1];
  }
  return @matches;
}

sub _does_match_border_symbol {
  my $match = shift;

  # Get the coordinates of the first and last digit of the match
  my ($x0, $y0) = _get_grid_coordinates_to_string_position($match->[1]);
  my ($x1, $y1) = _get_grid_coordinates_to_string_position($match->[2]);

  die if $y0 != $y1; # sanity check for matches spanning multiple grid lines

  # Calculate the outermost border of the sub-array of all neighbours
  my $left = $x0 == 0 ? 0 : $x0 - 1;
  my $right = $x1 == $grid_width - 1 ? $x1 : $x1 + 1;
  my $top = $y0 == 0 ? 0 : $y0 - 1;
  my $bottom = $y0 == $grid_height - 1 ? $y0 : $y0 + 1;

  # Slice the 2d-array using the calculated boundaries
  my @grid_slice = map { [ @{$_}[$left .. $right] ] } @data_grid[$top .. $bottom];

  my $flat_slice = join "", map { @{$_} } @grid_slice;
  return $flat_slice =~ /[^0-9.]/;
}

=pod

The data grid contains a two dimensional array representing the engine plan. The coordinate system
has its root on the top left and extends down and to the right, as such:

    | coordinate 0/0
    V
    #XXXXX
    YOOOOO
    YOOOOO
    YOOOOO

=cut
sub _get_grid_coordinates_to_string_position {
  my $position = shift;
  my $y = int($position / $grid_width);
  my $x = $position % $grid_width;
  return ($x, $y);
}

task1();
task2();
