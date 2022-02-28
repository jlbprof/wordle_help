#!/usr/bin/perl

use strict;
use warnings;

use Carp;
use Getopt::Long;

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
	print "usage: TBD\n";

	exit 0;
}

sub script
{
	my (@args) = @_;

    my @words;
    my @clues;
    foreach my $arg (@args) {
        if (length($arg) == 5)
        {
            push @words, $arg;
            next;
        }
        elsif (length ($arg) == 2 && substr ($arg, 0, 1) eq "X") {
            push @clues, $arg;
            next;
        }
        elsif (length ($arg) == 3 && (substr ($arg, 0, 1) eq "A") || substr ($arg, 0, 1) eq "N") {
            push @clues, $arg;
            next;
        }
        else {
            die "Unknown arg $arg";
        }
    }

    if (@words == 0) {
        die "No words provided";
    }

    if (@words == 1) {
        my @cmd;

        push (@cmd, './wordle_best_from.pl', @clues, "XXX", qw(CA2 CE2 CI2 CO2 CU1 CS1 CT1 CR1 CL1));

        system (@cmd);

        exit 0;
    }
    else {
        my @cmd;

        push (@cmd, './wordle_help.pl', @clues);

        system (@cmd);

        exit 0;
    }

	return 1;
}

script (@ARGV) unless caller ();


