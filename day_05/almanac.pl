#!/usr/bin/env perl

package AOC::Almanac::Table;

sub new {
  my $class = shift;
  my $self = {
    destinations => $_[0],
    sources => $_[1],
    range => $_[2],
  };
  return bless $self => $class;
}

=pod

Takes an input like:

    12 34 56
    0 1 2

To build a valid instance of the class.

=cut
sub parse {
  my $input = shift;
  my (@destinations, @sources, @range);
  foreach my $line (split "\n", $input) {
    my @values = split m/\s+/, $line;
    next if @values != 3; # not a line with values to add
    push @destinations, int($values[0]);
    push @sources, int($values[1]);
    push @range, int($values[2]);
  }
  return AOC::Almanac::Table->new(\@destinations, \@sources, \@range);
}

sub lookup {
  my $self = shift;
  my $source = shift;

  for (my $i = 0; $i <= $#{$self->{destinations}}; $i++) {
    my $start = $self->{sources}->[$i];
    my $end = $start + $self->{range}->[$i];
    if ($source >= $start && $source <= $end) {
      my $offset = $source - $start;
      return $self->{destinations}->[$i] + $offset;
    }
  }
  return $source;
}

package AOC::Almanac;

sub new {
  my $class = shift;
  my @almanac_tables = @_;
  my $self = {
    tables => \@almanac_tables,
  };
  return bless $self => $class;
}

sub parse {
  my @almanac_table_inputs = @_;
  my @almanac_tables;
  foreach my $input (@almanac_table_inputs) {
    push @almanac_tables, AOC::Almanac::Table::parse($input);
  }
  return AOC::Almanac->new(@almanac_tables);
}

sub lookup {
  my $self = shift;
  my $source = shift;
  my $target = $source;
  for (my $i = 0; $i <= $#{$self->{tables}}; $i++) {
    $target = $self->{tables}->[$i]->lookup($target);
  }
  return $target;
}

package main;

use strict;
use warnings;

open my $fh, '<', 'input.txt' or die;
local $/ = undef;
our $contents = <$fh>;
close $fh;

our (@seeds, $almanac);

sub preprocess {
  my $input = shift;
  my @input_blocks = split "\n\n", $input;
  @seeds = ($input_blocks[0] =~ m/\d+/g);
  $almanac = AOC::Almanac::parse(@input_blocks[1..$#input_blocks]);
}

sub task1 {
  my $lowest_location = -1;
  foreach my $seed (@seeds) {
    my $location = $almanac->lookup($seed);
    if ($lowest_location == -1 or $location < $lowest_location) {
      $lowest_location = $location;
    }
  }
  print "The lowest location is $lowest_location!\n";
}

preprocess($contents);
task1();
