#!/usr/bin/env perl

use strict;
use warnings;

open my $fh, '<', 'input.txt' or die;
local $/ = undef;
our $contents = <$fh>;
close $fh;

our %ranks = (
  A => 14, K => 13, Q => 12, J => 11, T => 10, 9 => 9, 
  8 => 8, 7 => 7, 6 => 6, 5 => 5, 4 => 4, 3 => 3, 2 => 2
);

our @hands = preprocess($contents);

sub preprocess {
  my $input = shift;
  my @output;
  foreach my $line (split "\n", $input) {
    my ($cards, $bid) = split " ", $line, 2;
    push @output, [ [split //, $cards ], $bid ];
  }
  return @output;
}

sub task1 {
  my @ordered_hands = sort {
    _cmp_type_of_hand($a->[0], $b->[0]) || _cmp_high_cards($a->[0], $b->[0])
  } @hands;
  my $sum = 0;
  for (my $i = 0; $i <= $#ordered_hands; $i++) {
    $sum += $ordered_hands[$i]->[1] * ($i + 1);
  }
  print "The total amount of total winnings is $sum!\n";
}

sub _cmp_type_of_hand {
  my @card_count_a = _get_card_counts(shift);
  my @card_count_b = _get_card_counts(shift);
  for (my $i = 0; $i <= $#card_count_a; $i++) {
    if ($card_count_a[$i] != $card_count_b[$i]) {
      return $card_count_a[$i] <=> $card_count_b[$i];
    }
  }
  return 0;
}

sub _cmp_high_cards {
  my $cards_a = shift;
  my $cards_b = shift;
  for (my $i = 0; $i <= $#{$cards_a}; $i++) {
    my $rank_a = $ranks{$cards_a->[$i]};
    my $rank_b = $ranks{$cards_b->[$i]};
    if ($rank_a != $rank_b) {
      return $rank_a <=> $rank_b;
    }
  }
  return 0;
}

sub _get_card_counts {
  my $hand = shift;
  my %card_counts;
  for my $card (@{$hand}) {
    $card_counts{$card}++;
  }
  return sort { $b <=> $a } values %card_counts;
}

task1();
