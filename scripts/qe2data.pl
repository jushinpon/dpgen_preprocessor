=b
original files from read-in sout folder
ori.lmp
ori.sout
ori.in

=cut
use warnings;
use strict;
use JSON::PP;
use Data::Dumper;
use Cwd;
use POSIX;

sub qe2data{

my ($sys_para_hr) = @_;

my $input_file = `grep -v "#" $sys_para_hr->{read_file}`;#input_path.dat indicating path and filename
chomp $input_file;
my @natom = `cat $input_file|sed -n '/number of atoms\\/cell/p'|awk '{print \$5}'`;	
#@natom could more than 1 for vc-relax,so the array should be used
my $natom = $natom[0];#must use array for `` output in Perl
chomp $natom;#atom number for data file
#print "\$natom:$natom\n";
die "You don't get the Atom Number in the DFT sout file, $input_file!!!\n" unless($natom);
#check qe input
chomp $input_file;
my $dir = `dirname $input_file`;#get path
chomp $dir;#folder includes all files 
#print "dirname: $dir\n";
my @QEinput = `find $dir -type f -name "*.in"`;#find the corresponding QE in file
my $inputNo = @QEinput;
die "only one QE input file can be found\n" if ($inputNo != 1);
chomp @QEinput;
my $QEinput = $QEinput[0];
#print "QEinput: $QEinput\n";

my $QEnat = `cat $QEinput|sed -n '/nat =/p'|awk '{print \$3}'`;#atom number from QE input file	
chomp $QEnat;
die "You don't get the Atom Number in the DFT input file, $QEinput!!!\n" unless($QEnat);
die "the Atom Number in the DFT sout ($input_file) and dftin ($QEinput) files are not the same or no dft input file!!!\n" if($natom != $QEnat);
#get calculation type
#check QE calculation type to decide which data can be
my @cal_type = `grep calculation  $QEinput`;#|grep "calculation"`;	
chomp @cal_type;
$cal_type[0] =~ /\s*calculation\s*=\s*"(.+)"/;#must use array
chomp $1;
my $cal_type = $1;
die "no calculation type in  $QEinput\n" unless($cal_type);

#check types
my $types = `grep -v "#" $dir/elements.dat`;
$types =~ s/^\s+|\s+$//;
my @types = split (/\s+/,$types);
my %id2type;#atom id to its element type id
my %typeNo;

for (0..$#types){
    chomp;
   # print "element: $_\n";
    $id2type{$_} = $types[$_];
    $typeNo{"$types[$_]"}++;
    
}
my $total = 0;
my %ele2type;#element symbol to lmp type id
my $counter = 0;#counter for lmp type
for (sort keys %typeNo){
    $counter++;
    $ele2type{$_} = $counter;
    print "element: $_, number: $typeNo{$_}, lmp type: $ele2type{$_}\n";
    $total += $typeNo{$_};
}
print "Total element No. in elements.dat: $total\n";
my $element_types = keys %typeNo;

`cp $input_file $sys_para_hr->{output_folder}/ori.sout`;
`cp $QEinput $sys_para_hr->{output_folder}/ori.in`;

if($cal_type eq "scf"){
    my $temp = `grep "!" $input_file`;
    chomp $temp;
    $temp =~ s/^\s+|\s+$//;
    die "The scf in $input_file hasn't done (no '!    total energy')! 
    You need to do scf with a larger electronmic step number or check your structure!\n" unless ($temp);
}
else{
    my $temp = `grep "End of BFGS Geometry Optimization" $input_file`;
    chomp $temp;
    $temp =~ s/^\s+|\s+$//; 

    die "The vc-relax or relax in $input_file hasn't done (no 'End of BFGS Geometry Optimization')! 
    You need to do vc-relax with a larger nstep value or drop this case by modifying all_setting.pm!\n" unless ($temp);
}
#get box information for lammps
my @box;
if($cal_type eq "scf"){
    my @CellVec = `grep -A 3 "CELL_PARAMETERS" $QEinput`;
    chomp @CellVec; 
    for (@CellVec){
      if(m/^\s*([-+]?\d+\.?\d*e?[+-]?\d*)\s+([-+]?\d+\.?\d*e?[+-]?\d*)\s+([-+]?\d+\.?\d*e?[+-]?\d*)/){
    		push @box, [$1,$2,$3];
      }	
    }    
    die "The no cell information in $QEinput\n" unless (@box);
}
else{
    my @CellVec = `grep -A 3 "CELL_PARAMETERS (angstrom)" $input_file`;
    chomp @CellVec; 
    for (@CellVec){
      if(m/^\s*([-+]?\d+\.?\d*e?[+-]?\d*)\s+([-+]?\d+\.?\d*e?[+-]?\d*)\s+([-+]?\d+\.?\d*e?[+-]?\d*)/){
    		push @box, [$1,$2,$3];
      }	
    }    
    die "The no cell information in $input_file\n" unless (@box);
}

my $a = ( ${$box[-3]}[0]**2.0 + ${$box[-3]}[1]**2.0 + ${$box[-3]}[2]**2.0 )**0.5;
my $b = ( ${$box[-2]}[0]**2.0 + ${$box[-2]}[1]**2.0 + ${$box[-2]}[2]**2.0 )**0.5;
my $c = ( ${$box[-1]}[0]**2.0 + ${$box[-1]}[1]**2.0 + ${$box[-1]}[2]**2.0 )**0.5;
my $cosalpha = (${$box[-2]}[0]*${$box[-1]}[0] + ${$box[-2]}[1]*${$box[-1]}[1] + ${$box[-2]}[2]*${$box[-1]}[2])/($b*$c);
my $cosbeta =  (${$box[-1]}[0]*${$box[-3]}[0] + ${$box[-1]}[1]*${$box[-3]}[1] + ${$box[-1]}[2]*${$box[-3]}[2])/($c*$a);
my $cosgamma = (${$box[-3]}[0]*${$box[-2]}[0] + ${$box[-3]}[1]*${$box[-2]}[1] + ${$box[-3]}[2]*${$box[-2]}[2])/($a*$b);
#https://docs.lammps.org/Howto_triclinic.html
my $lx = $a;
my $xy = $b*$cosgamma;
my $xz = $c*$cosbeta;
my $ly = sqrt($b**2.0 - $xy**2.0);
my $yz = ($b*$c*$cosalpha-$xy*$xz)/$ly;
my $lz = sqrt($c**2.0 - $xz**2.0 - $yz**2.0);

#get coordinates

############## coord ############
##ATOMIC_POSITIONS (angstrom)        
##Al           -0.0000004209       -0.0000004098       -0.0000002490
#ATOMIC_POSITIONS {angstrom} for input file
my @coord1 = `grep -A $natom "ATOMIC_POSITIONS {angstrom}" $QEinput`;
my @coord2 = `grep -A $natom "ATOMIC_POSITIONS (angstrom)" $QEinput`;
my @coord3 = `grep -A $natom "ATOMIC_POSITIONS (angstrom)" $input_file`;
my @coord = (@coord1,@coord2,@coord3);
chomp @coord;
my @tempcoord;
for(@coord){
	chomp;
	#print "$_\n";
	#if(m/^\w+\s+([-+]?\d+\.?\d*)\s+([-+]?\d+\.?\d*)\s+([-+]?\d+\.?\d*)/){
	if(m/^(\w+)\s+([-+]?\d+\.?\d*e?[+-]?\d*)\s+([-+]?\d+\.?\d*e?[+-]?\d*)\s+([-+]?\d+\.?\d*e?[+-]?\d*)/){
		#print "**$_\n";
        chomp ($1,$2,$3,$4);
        my $lmptype = $ele2type{$1};
		push @tempcoord, [$lmptype,$2,$3,$4];
	}	
}
   die "no coord was found in $QEinput and $input_file\n" unless (@tempcoord);
my $tempcoord = @tempcoord/$natom;#how many coordinate set (frame)
my @lmp_coor;
my $coun = 0;
for (-$natom..-1){#only need the last frame for lmp data
	$coun++;
    my $temp = "$coun ". join(" ",@{$tempcoord[$_]});
    #print "$coun $temp\n";
	chomp $temp;
    push @lmp_coor,$temp;
}

#begin make lmp data file
#prefix lmp is for atomsk cif convertion
open my $data ,"> $sys_para_hr->{output_folder}/ori.lmp";#original data file from QE output
print $data "LAMMPS data file\n";#print the head line
print $data "\n$natom atoms\n";
print $data "$element_types atom types\n";#lmp data
#output box to lmp file
print $data "\n0.0 $lx xlo xhi\n";
print $data "0.0 $ly ylo yhi\n";
print $data "0.0 $lz zlo zhi\n";
print $data "$xy $xz $yz xy xz yz\n\n";

print $data "\nAtoms\n\n";
for (@lmp_coor){
    print $data "$_\n";
}

close($data);
`cp $sys_para_hr->{output_folder}/ori.lmp $sys_para_hr->{output_folder}/ori.data`;#for dpgen labelling
}# end sub
1;