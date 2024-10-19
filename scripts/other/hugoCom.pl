#!/usr/bin/perl
use strict;
use warnings;
use File::Find;
use File::Basename;

sub indexDir {
    my ($filter) = @_;
    my $startDir = "/home/rocky/github.com/DnFreddie/Notes/content/posts/";

    unless ( -d $startDir ) {
        die "Directory $startDir does not exist or is not a directory.";
    }

    my @files;
    find(
        sub {
            return if -d $_;
            push @files, $File::Find::name;
        },
        $startDir
    );

    my @mapArray;
    for my $file (@files) {
        my $file_name = File::Basename::basename($file);
        $file_name =~ s/\..*$//;

        my ($relative_path) = $file =~ m!(posts/.*)!;

        if ( !defined $relative_path ) {
            warn "Could not find 'posts/' in path: $file\n";
            next;
        }

        if ( $file_name =~ /$filter/i ) {
            push @mapArray,
              {
                name => $file_name,
                path => $relative_path
              };
        }
    }

    return @mapArray;
}

sub replace {
    my ($strings) = @_;
    return
      sprintf( '[%s]({{< ref "%s">}})', $strings->{name}, $strings->{path} );
}

sub main {
    while ( my $inputText = <STDIN> ) {
        chomp $inputText;

        next unless $inputText;

        $inputText =~ s/\[(.*?)\]/
            my @matches = indexDir($1);
            if (@matches) {
                replace($matches[0]);  
            } else {
                "[$1]";  
            }
        /ge;

        print $inputText, "\n";
    }
}

main();

