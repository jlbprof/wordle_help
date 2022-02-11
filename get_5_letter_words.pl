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
    print "usage: get_5_letter_words.pl word_file\n";

    exit 0;
}

sub script
{
    my (@args) = @_;

    usage ("Need a word file 1") if @args != 1;

    my $fname = $args[0];

    usage ("Need a word file 2") if !-e $fname;

    if (open my $fh, "<", $fname) {
        while (<$fh>) {
            my $word = uc($_);
            $word =~ s/[^A-Z]//g;
            next if length($word) != 5;
            print $word . "\n";
        }
        close $fh;
    }
    else {
        die "Unable to open word file ($fname)";
    }

    return 1;
}

script (@ARGV) unless caller ();


