#!/usr/bin/env perl

package AOC::Almanac::Table;

sub new {
  my $class = shift;
  my $self = {
    destinations => $_[0],
    sources => $_[1],
    range => $_[2],
  };
  return bless \%self => $class;
}

=pod

Takes an input like:

    12 34 56
    0 1 2

To build a valid instance of the class.

=cut
sub parse {
  my $input = shift;
  my @destinations, @sources, @range;
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

}

package main;

use strict;
use warnings;

open my $fh, '<', 'input.txt' or die;
local $/ = undef;
our $contents = <$fh>;
close $fh;
