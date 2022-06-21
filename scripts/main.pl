#!/usr/bin/perl
=b
1. structures need to do vc-relac, and the optimized structures will be used later (scale, or deform with random perturbation).
2. structures from materials project for scaling only (with random perturbation ).
pw.x的输入说明见INPUT_PW。注意默认的单位，其中原子单位制为（以下数值见源程序q-e-qe-6.3/Modules/constants.f90）：
parameters in QE fortran:
1 bohr = 1 a.u. (atomic unit) = 0.52917720859 angstroms.
1 Rydberg (Ry) = 13.60569193 eV

parameters in dpdata:
ry2ev = 13.605693009
bohr2ang = 0.52917721067
kbar2evperang3 = 1.0/1602.1766208
# the following are files for dpgen initial folder
Al.data: for lmp labeling
Al.in: getting input structure of QE
Al.sout: getting the ref data (energy, force, virial...) 
dpE2expE.dat: make lammps energy reflect exp energy
elements.dat: for coverting type.raw of different npy combination.
kpoints.dat: for QE
masses.dat:
type.raw: for dp train (from elements.dat)

kpoints.dat
--nodelist=node0xx 
=cut
use strict;
use warnings;
use Cwd;
use Data::Dumper;
use lib '.';#also find local module
use Expect;  
#use elements;#info about single elements or custom 
use system_setting;#parameters for system setting
#get system parameters first
require './qe2data.pl';
require './deform.pl';

my ($deform_hr,$sys_para_hr) = 
&system_setting::sys_setting();

#folder to put generated files
`rm -rf $sys_para_hr->{output_folder}`;
`mkdir -p $sys_para_hr->{output_folder}`;

#check whether required files exist, which make dpgen work directly
my @required_files = ("dpE2expE.dat","elements.dat","kpoints.dat");#type.raw can be got by elements.dat
my $read_in = `grep -v "#" $sys_para_hr->{read_file}`;#need kpoints.dat in the same folder for QE
chomp $read_in;
my $base = `basename $read_in`;
chomp $base;
$base =~ s/^\s+|\s+$//;
print "basename: $base\n";

$base =~ /(.*)\.\w+/;
my $pre_in = $1;
my $dir = `dirname $read_in`;#get path
chomp $dir;
print "dirname: $dir\n";
my @QEinput = `find $dir -type f -name "*.in"`;#sout or other types`;
chomp @QEinput;
my $inputNo = @QEinput;
print "@QEinput\n";
die "only one QE input file can be found. Current: $inputNo\n" if ($inputNo != 1);
my $QEinput = $QEinput[0];
print "QEinput: $QEinput\n";

for (@required_files){
    die "No $_ in $dir\n" unless(-e "$dir/$_");
    `cp $dir/$_ $sys_para_hr->{output_folder}`;
}

my $currentPath = $sys_para_hr->{current_dir};# dir for all scripts
my $file_type = $sys_para_hr->{read_type};#vc_relax, relax, scf, md,vc_md, data

#make an reference data file in output folder for deforming
&qe2data($sys_para_hr);
&deform($deform_hr,$sys_para_hr);