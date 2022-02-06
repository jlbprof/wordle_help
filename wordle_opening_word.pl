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

sub usage_help
{
	print "usage: wordle_opening_word.pl [ranking_rule]\n";
    print "   clues: CA1 - Contains an A and rank that as 1\n";
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

sub validate_clue
{
    my ($clue) = @_;

    my $clue_type = substr ($clue, 0, 1);

    if ($clue_type ne "C" &&
        $clue_type ne "D")
    {
        usage ("Invalid clue ($clue)");
    }

    usage ("Invalid clue ($clue)") if (($clue_type eq "C") && length ($clue) != 3);
    usage ("Invalid clue ($clue)") if (($clue_type eq "D") && length ($clue) != 1);

    return;
}

my %words;

sub apply_clue
{
    my ($clue) = @_;

    my $clue_type = substr ($clue, 0, 1);

    my $char = substr ($clue, 1, 1);

    my $rank = substr ($clue, 2, 1) if ($clue_type eq "C");

    my $total_rank = 0;

    foreach my $word (keys %words)
    {
        if ($clue_type eq "C")
        {
            if ($word =~ m/$char/)
            {
                $words{$word} += $rank;
            }
        }
        elsif ($clue_type eq "D")
        {
            my @array = split (//, $word);
            @array = sort @array;

            for (my $i = 1; $i < 5; ++$i)
            {
                my $x = $array[$i];
                my $y = $array[$i - 1];

                if ($x eq $y)
                {
                    delete $words{$word};
                }
            }
        }
    }
}

sub script
{
	my (@clues) = @_;

    my $show;

    my @xclues = @clues;
    @clues = ();
    foreach my $clue (@xclues) {
        if ($clue eq "--help") {
            usage_help ();
            exit 0;
        }
        validate_clue ($clue);
        push (@clues, $clue);
    }

    my $word_file = 'words_alpha_5_letters.txt';
    my @words;

    usage_help ();
    print "\n";

    exit 0 if (!@clues);

    if (open my $fh, "<", $word_file) {
        while (<$fh>) {
            my $word = $_;
            $word =~ s/[^A-Z]//g;
            push (@words, $word);
        }
        close $fh;
    }
    else {
        die "Cannot open $word_file";
    }

    foreach my $word (@words) {
        $words{$word} = 0;
    }

    foreach my $clue (@clues) {
        apply_clue ($clue);
    }

    my @list;
    foreach my $word (keys %words) {
        my $str = sprintf ("%03d%s", $words{$word}, $word); 
        push (@list, $str);
    }
    my @sorted_list = reverse sort @list;

    for my $i (1 .. 25) {
        my $str = $sorted_list[$i];
        my $rank = substr($str, 0, 3);
        my $word = substr($str, 3);

        printf ("%5s %3d\n", $word, $rank);
    }

	return 1;
}

script (@ARGV) unless caller ();


