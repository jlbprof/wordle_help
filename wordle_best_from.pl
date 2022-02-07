#!/usr/bin/perl

use strict;
use warnings;

use Carp;
use Getopt::Long;

require './wordle_help.pl';
require './wordle_opening_word.pl';

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

sub usage_help
{
	print "usage: wordle_best_from.pl clue1 .. clueN XXX rank1 .. rankN\n";
    print "       Select more strategic words from the resulting word list\n";
    print "   clues: AX3, character X is at position 3\n";
    print "          NX3, character X is present but NOT at position 3\n";
    print "          XX,  character X is NOT present\n";
    print "   ranks: CA1 - Contains an A and rank that as 1\n";
    print "          D   - no duplicates\n";
    print "   Positions are 1 based\n";

    return;
}

sub usage
{
	my ($msg) = @_;

	print "Error: $msg\n";
    usage_help ();

	exit 0;
}

sub script
{
	my (@args) = @_;

    my $show;

    my @xargs = @args;
    my @clues;
    my @ranks;

    my $found_xxx;
    foreach my $clue (@xargs) {
        if ($clue eq "--help") {
            usage_help ();
            exit 0;
        }

        if (!$found_xxx) {
            if ($clue eq "XXX") {
                $found_xxx = 1;
                next;
            }

            wordle::help::validate_clue ($clue);
            push (@clues, $clue);
        }
        else {
            wordle::opening_word::validate_rank ($clue);
            push (@ranks, $clue);
        }
    }

    my @solutions = wordle::help::get_possible_solutions (@clues);

    wordle::opening_word::set_words (@solutions);
    wordle::opening_word::set_ranks (@ranks);
    wordle::opening_word::process_ranks ();

	return 0;
}

script (@ARGV) unless caller ();


