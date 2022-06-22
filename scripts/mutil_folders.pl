#!/usr/bin/perl
=b
If you want to deform many cases at a time, you may use this script.
You need to modify $source_folder where you store all your source folders
=cut
use strict;
use warnings;
use Cwd;

my $source_folder = "/home/jsp/dp_prprocessor/dpgen_preprocessor/examples";#all cases you want to work on
#input_path.dat
my @files = `find $source_folder -type f -name "*.sout"`;#sout or other types`;
chomp @files;
for my $f (@files){ 

    `rm -f ./input_path.dat`;
    `touch ./input_path.dat`;
    `echo $f >> ./input_path.dat`;
    system("cat ./input_path.dat");
    my $base = `basename $f`;
    chomp $base;
    $base =~ s/^\s+|\s+$//;
    print "basename: $base\n";
    $base =~ /(.*)\.\w+/;
    my $pre_in = $1;
    my $dir = `dirname $f`;#get path
    print "dirname: $dir\n";
    system("perl ./main.pl");
    sleep(1);

    system("rm -rf $pre_in");
    system("mv output $pre_in");

}
