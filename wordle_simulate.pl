#!/usr/bin/perl

use strict;
use warnings;

package wordle::simulate;

use Carp;
use Getopt::Long;

require './wordle_help.pl';

$| = 1;

$SIG{__WARN__} = sub {
	my ($sig) = @_;

	print "WARN :$sig:\n";

	print Carp->longmess . "\n";

	exit 0;
};

$SIG{__DIE__} = sub {
	my ($sig) = @_;

	print "DIE :$sig:\n";
	print Carp->longmess . "\n";

	exit 0;
};

$SIG{TERM} = sub {
	my ($sig) = @_;

	exit 0;
};

$SIG{INT} = sub {
	my ($sig) = @_;

	exit 0;
};

sub usage
{
	my ($msg) = @_;

	print "Error: $msg\n";
	print "usage: wordle_simulate.pl solution first_guess\n";

	exit 0;
}

sub script
{
	my (@args) = @_;

	my $solution = $args [0];
    my $first_guess = $args [1];

    usage ("Please provide a solution") if !$solution;
    usage ("Solution must be 5 characters") if length ($solution) != 5;
    usage ("Please provide a first guess") if !$first_guess;
    usage ("First guess must be 5 characters") if length ($first_guess) != 5;

    usage ("Congratulations you win") if ($solution eq $first_guess);

    my @solution = split(//, $solution);
    my @first_guess = split(//, $first_guess);

    my @clues;

    for my $i (1 .. 5) {
        my $char_first    = $first_guess [$i - 1];
        my $char_solution = $solution [$i - 1];

        if ($char_first eq $char_solution) {
            push @clues, "A$char_first$i";
            next;
        }

        if ($solution =~ m/$char_first/) {
            push @clues, "N$char_first$i";
            next;
        }
        else {
            push @clues, "X$char_first";
            next;
        }
    }

    print "Clues\n";
    foreach my $clue (@clues) {
        print $clue . "\n";
    }

    my @results = wordle::help::get_possible_solutions (@clues);

    print "Num possible solutions after first guess :" . @results . ":\n";

	return 1;
}

script (@ARGV) unless caller ();


