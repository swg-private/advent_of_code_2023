#!/usr/bin/env perl

use strict;
use warnings;

open my $fh, '<', 'input.txt' or die;
local $/ = undef;
our $contents = <$fh>;
close $fh;

our @cards = preprocess($contents);

sub preprocess {
  my $input = shift;
  my @cards = split "\n", $input;
  my @output_cards;
  foreach my $card (@cards) {
    $card =~ s/Card\s+\d+://g;
    my ($winners, $havers) = split '\|', $card, 2;
    my %winners = _map_to_set($winners);
    my %havers = _map_to_set($havers);
    push @output_cards, [\%winners, \%havers];
  }
  return @output_cards;
}

sub task1 {
  my $sum = 0;
  foreach my $card (@cards) {
    my $winners = _get_amount_of_winners($card);
    $sum += 2 ** ($winners - 1) if $winners > 0;
  }
  print "The total value of the scratchcards is $sum!\n";
}

sub task2 {
  my $sum_of_cards = 0;
  for (my $i = 0; $i <= $#cards; $i++) {
    $sum_of_cards += _amount_of_won_cards($i);
  }
  print "The amount of cards is $sum_of_cards!\n";
}

sub _amount_of_won_cards {
  my $card_id = shift;
  my $sum = 1;
  my $winners = _get_amount_of_winners($cards[$card_id]);
  my $max_index = $card_id + $winners <= $#cards ? $card_id + $winners : $#cards;
  for (my $j = $card_id + 1; $j <= $max_index; $j++) {
    $sum += _amount_of_won_cards($j);
  }
  return $sum;
}

sub _get_amount_of_winners {
  my $card = shift;
  return scalar grep { exists $card->[0]->{$_} } keys %{$card->[1]};
}

sub _map_to_set {
  my $numbers = shift;
  my %numbers = map { $_ => 1 } split qr/\s/, $numbers;
  delete $numbers{''} if (exists $numbers{''});
  return %numbers;
}

task1();
task2();
