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
  my @number_matches = _get_all_matches_including_indices(qr/(\d+)/);
  my @asterisk_matches = _get_all_matches_including_indices(qr/(\*)/);
  my $sum = 0;
  foreach my $asterisk_match (@asterisk_matches) {
    my ($x, $y) = _get_grid_coordinates_to_string_position($asterisk_match->[1]);
    my @adjacent_numbers = map {$_->[0] + 0 } 
      grep _adjacent_to_asterisk($x, $y, $_), @number_matches;
    if (@adjacent_numbers == 2) {
      $sum += $adjacent_numbers[0] * $adjacent_numbers[1];
    }
  }
  print "The sum of all gear ratios is $sum!\n";
}

sub _adjacent_to_asterisk {
  my ($x, $y, $number_match) = @_;
  my ($xn0, $yn0) = _get_grid_coordinates_to_string_position($number_match->[1]);
  my ($xn1, $yn1) = _get_grid_coordinates_to_string_position($number_match->[2]);
  if (($xn1 < $x - 1 || $xn0 > $x + 1) || ($yn1 > $y + 1 || $yn1 < $y - 1)) {
    return 0;
  }
  return 1;
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

  my @grid_slice = _get_border_box_grid_slice($x0, $y0, $x1, $y1);

  my $flat_slice = join "", map { @{$_} } @grid_slice;
  return $flat_slice =~ /[^0-9.]/;
}

sub _get_border_box_grid_slice {
  my ($x0, $y0, $x1, $y1) = @_;

  # Calculate the outermost border of the sub-array of all neighbours
  my $left = $x0 == 0 ? 0 : $x0 - 1;
  my $right = $x1 == $grid_width - 1 ? $x1 : $x1 + 1;
  my $top = $y0 == 0 ? 0 : $y0 - 1;
  my $bottom = $y0 == $grid_height - 1 ? $y0 : $y0 + 1;

  # Slice the 2d-array using the calculated boundaries
  return map { [ @{$_}[$left .. $right] ] } @data_grid[$top .. $bottom];
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
