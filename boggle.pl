#!/usr/bin/perl
#
#  Boggle Solver - 2012/12/28  Austin Murphy
#

use strict;
#use warnings;

# Enhanced North American Benchmark Lexicon (ENABLE)
# a public domain word list
# 
#  Upper-case version 
my $wordfile = 'enable-UC.txt';


my @board;
my @used;

# main loop
while (1) {
  my @line;
  my $input;
  my $li=0;
  print "\n\n";
  print "Enter the Boggle board to solve, 4 rows of 4 letters. (for \"Qu\", just type Q)\n";

  while ($li < 4) {
    print "Row $li > ";
    chomp( $input = <> );
    if ( length( $input ) == 4 ) {
      @line = split(//, uc $input);
      for (0..3) {
        $board[$li][$_] = $line[$_];
      }
      $li+=1;
    } else {
      print "wrong number of letters, try again.\n";
    }
  
  }
  showboard();
  checkwords();

}

sub clearused {
  foreach my $l (0..3) {
    foreach my $c (0..3) {
      $used[$l][$c] = 0;
    }
  }
}

sub showboard {
  print "\n";
  print "Here is the board entered: \n";
  print "+---------+\n";
  foreach my $l (0..3) {
    print "| ";
    foreach my $c (0..3) {
      print "$board[$l][$c] ";
    }
    print "|\n";
  }
  print "+---------+\n\n";
}

sub checkwords {

  open (WL, $wordfile) or die "Where's $wordfile?";
  print "Searching for words ...\n";
  while (<WL>)
  {
    chomp;
    clearused();
    if ( findword($_) == 0 ) {
      print "$_\n";
    }
  }
  print "... done.\n";

}

sub findword() {

  my $word = shift;

  # min/max length
  if ( length($word) < 3 ) {
    return 1;
  } elsif (length($word) > 16 ) {
    return 1;
  }

  my @w = split(//, $word);

  return searchboard( \@w, 0, 0, 3, 3, \@used );
}

# recursively search for the letters of the word in the board
sub searchboard() {

  # string to search for
  my $wref = shift;
  my @w = @$wref;
  if (scalar @w == 0) {
    # Yay!
    return 0;
  }

  # search space 
  # row/column start/end
  my $rs = shift;
  my $cs = shift;
  my $re = shift;
  my $ce = shift;
  # correct for +/-1 past edges
  if ( $rs < 0 ) { $rs = 0; }
  if ( $cs < 0 ) { $cs = 0; }
  if ( $re > 3 ) { $re = 3; }
  if ( $ce > 3 ) { $ce = 3; }

  # used board locations
  my $usedref = shift;
  my @used = @$usedref;

  my $ltr = shift @w;
  # Qu is one "letter" in the boggle cubes
  if ($ltr eq 'Q' and $w[0] eq 'U') {
    shift @w;
  }

  for my $r ($rs .. $re) {
    for my $c ($cs .. $ce) {
      if ( $board[$r][$c] eq $ltr  && $used[$r][$c] == 0 ) {
        # found
        $used[$r][$c] = 1;
        if ( searchboard( \@w, $r-1, $c-1, $r+1, $c+1, \@used ) == 0 ) {
          return 0;
        }
        $used[$r][$c] = 0;
      }
    }
  }
  # not found
  return 1;
}



