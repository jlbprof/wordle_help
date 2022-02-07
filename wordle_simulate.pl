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

    my $solution = splice @args, 0, 1;

    usage ("Please provide a solution") if !$solution;
    usage ("Solution must be 5 characters") if length ($solution) != 5;
    usage ("Please provide at least one guess") if @args < 1;

    my @clues;
    my @new_clues;

    my @solution = split //, $solution;

    print "SOLUTION  $solution\n";

    foreach my $guess (@args) {
        usage ("Guess must be 5 characters ($guess)") if length ($guess) != 5;

        if ($guess eq $solution) {
            print "WIN\n";
            last;
        }

        print "-"x75 . "\n";
        print "GUESS     $guess\n";

        @new_clues = ();
        my @guess = split //, $guess;

        for my $i (1 .. 5) {
            my $char_first    = $guess [$i - 1];
            my $char_solution = $solution [$i - 1];

            if ($char_first eq $char_solution) {
                push @new_clues, "A$char_first$i";
                next;
            }

            if ($solution =~ m/$char_first/) {
                push @new_clues, "N$char_first$i";
                next;
            }
            else {
                push @new_clues, "X$char_first";
                next;
            }
        }

        my $clues = join (' ', @new_clues);
        print "NEW CLUES $clues\n";

        push (@clues, @new_clues);
        $clues = join (' ', @clues);

        print "CLUES     $clues\n";

        my @results = wordle::help::get_possible_solutions (@clues);
        my $num_words = @results;
        print "NUM WORDS $num_words\n";

        print "WORDS (20) ";
        for my $i (1 .. 20)
        {
            last if ($i > @results);
            print $results [$i-1] . " ";
        }
        print "\n";
    }

	return 1;
}

script (@ARGV) unless caller ();


