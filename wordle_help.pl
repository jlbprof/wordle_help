#!/usr/bin/perl

use strict;
use warnings;

package wordle::help;

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
    print "usage: wordle_help [clues]\n";
    print "   clues: AX3, character X is at position 3\n";
    print "          NX3, character X is present but NOT at position 3\n";
    print "          XX,  character X is NOT present\n";
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

    if ($clue_type ne "A" &&
        $clue_type ne "N" &&
        $clue_type ne "X")
    {
        usage ("Invalid clue ($clue)");
    }

    usage ("Invalid clue ($clue)") if (($clue_type eq "A" || $clue_type eq "N") && length ($clue) != 3);
    usage ("Invalid clue ($clue)") if ($clue_type eq "X" && length ($clue) != 2);

    return;
}

sub look_for_conflicting_clues
{
    my (@clues) = @_;

    my %lookup;

    for my $clue (@clues) {
        my ($clue_type, $char, $pos) = split //, $clue;
        if (!exists $lookup{$char}) {
            $lookup{$char} = { $clue_type => [ $clue ] };
        }
        else {
            if (exists $lookup{$char}->{$clue_type})
            {
                push (@{ $lookup{$char}->{$clue_type} }, $clue);
            }
            else
            {
                $lookup{$char}->{$clue_type} = [ $clue ];
            }
        }
    }

    # Check for X and A or N first

    for my $char (keys %lookup)
    {
        my @keys = keys %{ $lookup{$char} };
        next if @keys == 1;

        if (exists $lookup{$char}->{X} && (exists $lookup{$char}->{A} || $lookup{$char}->{N})) {
            my $clues = "";
            foreach my $clue_type (keys %{ $lookup{$char} })
            {
                $clues .= " " if ($clues ne "");
                $clues = $clues . join (' ', @{ $lookup{$char}->{$clue_type} });
            }

            die "Conflicting clues :$clues:";
        }
    }

    # Check to see if N and A mention the same position

    for my $char (keys %lookup)
    {
        my @keys = keys %{ $lookup{$char} };
        next if @keys == 1;

        my %n_lookup;
        my %a_lookup;

        next if (!exists $lookup{$char}->{A});
        next if (!exists $lookup{$char}->{N}); # both have to be present to conflict

        foreach my $clue (@{ $lookup{$char}->{A} }) {
            my ($clue_type, $char, $pos) = split //, $clue;
            $a_lookup{$pos} = 1;
        }

        foreach my $clue (@{ $lookup{$char}->{N} }) {
            my ($clue_type, $char, $pos) = split //, $clue;
            $n_lookup{$pos} = 1;
        }

        foreach my $pos (keys %n_lookup) {
            if (exists $a_lookup{$pos}) {
                my $clues = "";
                foreach my $clue_type (keys %{ $lookup{$char} })
                {
                    $clues .= " " if ($clues ne "");
                    $clues = $clues . join (' ', @{ $lookup{$char}->{$clue_type} });
                }

                die "Conflicting clues :$clues:";
            }
        }

        foreach my $pos (keys %a_lookup) {
            if (exists $n_lookup{$pos}) {
                my $clues = "";
                foreach my $clue_type (keys %{ $lookup{$char} })
                {
                    $clues .= " " if ($clues ne "");
                    $clues = $clues . join (' ', @{ $lookup{$char}->{$clue_type} });
                }

                die "Conflicting clues :$clues:";
            }
        }
    }

    return;
}

sub apply_clue
{
    my ($clue, @words) = @_;
    my @output;

    my ($clue_type, $char, $pos) = split //, $clue;

    foreach my $word (@words)
    {
        if ($clue_type eq "A")
        {
            next if substr ($word, ($pos - 1), 1) ne $char;
        }
        elsif ($clue_type eq "N")
        {
            next if $word !~ m/$char/;
            next if substr ($word, ($pos - 1), 1) eq $char;
        }
        else # ($clue_type eq "X")
        {
            next if ($word =~ m/$char/);
        }

        push (@output, $word);
    }

    return @output;
}

sub get_possible_solutions
{
    my (@clues) = @_;

    my $word_file = 'words_alpha_5_letters.txt';
    my @words;

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

    my @current = @words;
    foreach my $clue (@clues) {
        @current = apply_clue ($clue, @current);
    }

    return @current;
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
        if ($clue eq "--show") {
            $show = 1;
            next;
        }
        validate_clue ($clue);
        push (@clues, $clue);
    }

    look_for_conflicting_clues (@clues);

    usage_help ();
    print "\n";

    exit 0 if (!@clues);

    my @current = get_possible_solutions (@clues);
    my $num = @current;

    if ($show || $num < 100)
    {
        foreach my $word (@current) {
            print $word . "\n";
        }
    }

    print "Num remaining words $num\n";

    return 1;
}

script (@ARGV) unless caller ();


