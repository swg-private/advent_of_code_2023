#!/usr/bin/env perl

use strict;
use warnings;
use List::Util qw(sum);

our %number_words = (
  zero => 0,
  one => 1,
  two => 2,
  three => 3,
  four => 4,
  five => 5,
  six => 6,
  seven => 7,
  eight => 8,
  nine => 9,
);

open my $fh, '<', 'input.txt' or die;
local $/ = undef;
my $contents = <$fh>;
close $fh;

sub task1 {
  my $input = shift;
  my @lines = split '\n', $input;
  my $total_calibration = sum map _get_two_digit_calibration_number($_), @lines;
  print "The calibration number is " . $total_calibration . "!\n";
}

sub _get_two_digit_calibration_number {
  my $line = shift;
  $line =~ m/^\D*(\d).*?(\d?)\D*$/;
  unless (defined($2) && $2 ne "") {
    return "$1$1" + 0;
  }
  return "$1$2" + 0;
}

sub task2 {
  my $input = shift;
  my @lines = split '\n', $input;
  my $total_calibration = sum map _get_two_digit_calibration_number_including_words($_), @lines;
  print "The calibration number including words is " . $total_calibration . "!\n";
}

sub _get_two_digit_calibration_number_including_words {
  my $line = shift;
  my @matches = ($line =~ m/(?=(\d|zero|one|two|three|four|five|six|seven|eight|nine))/g);
  my $first_digit = ($matches[0] =~ m/\d/ ? $matches[0] : $number_words{$matches[0]});
  my $last_digit = ($matches[$#matches] =~ m/\d/ ? $matches[$#matches] : $number_words{$matches[$#matches]});
  return "$first_digit$last_digit" + 0;
}

task1($contents);
task2($contents);
