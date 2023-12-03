#!/usr/bin/env perl

use strict;
use warnings;
use List::Util qw(reduce);

open my $fh, '<', 'input.txt' or die;
local $/ = undef;
my $contents = <$fh>;
close $fh;

sub task1_and_2 {
  my $input = shift;
  my @games = split '\n', $input;
  
  my %max_number_of_cubes = (
    red => 12,
    green => 13,
    blue => 14,
  );
  
  my $sum_of_game_ids = 0;
  my $sum_of_cube_cubes = 0;
  foreach my $game (@games) {
    my $game_id = ($game =~ m/Game (\d+)/g)[0];
    my @matches = ($game =~ m/(\d+) (red|green|blue)/g);
    my $impossible = 0;
    my %minimum_amount_of_cubes = (
      red => 0,
      green => 0,
      blue => 0,
    );
    for (my $i = 0; $i <= $#matches; $i = $i + 2) {
      my $number_of_cubes = $matches[$i];
      my $cube_colour = $matches[$i + 1];
      if ($number_of_cubes > $minimum_amount_of_cubes{$cube_colour}) {
        $minimum_amount_of_cubes{$cube_colour} = $number_of_cubes;
      }
      unless ($number_of_cubes <= $max_number_of_cubes{$cube_colour}) {
        $impossible = 1;
      }
    }
    $sum_of_game_ids += $game_id unless $impossible;
    $sum_of_cube_cubes += reduce { $a * $b } values %minimum_amount_of_cubes;
  }
  print "The total sum of game IDs is $sum_of_game_ids!\n";
  print "The total sum of cube cubes is $sum_of_cube_cubes!\n";
}

task1_and_2($contents);
