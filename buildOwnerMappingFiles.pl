#!/usr/bin/perl

# Process each Instance Owner Review tab delimited files and
# create mapping files of system to owner and key name to owner.

my $InstanceId, $State, $KeyName, $Name, $group, $system, $owner;
my %mapSystem;
my %mapKeyName;
my @count;
my $home = $ENV{"HOME"};

open(IN, "$home/data/ownerTags/preprod-us-east-1-ownerTags.dat") or die "Can't open file";
processFile();
open(IN, "$home/data/ownerTags/preprod-us-west-2-ownerTags.dat") or die "Can't open file";
processFile();
open(IN, "$home/data/ownerTags/prod-us-east-1-ownerTags.dat") or die "Can't open file";
processFile();
open(IN, "$home/data/ownerTags/prod-us-west-2-ownerTags.dat") or die "Can't open file";
processFile();

# System Mapping file has been manually created from Project Leads spreadsheet
#open(OUT, ">$home/data/ownerTags/systemMappings.dat") or die "Can't open file";
#print OUT "system\towner\n";
#foreach my $key ( keys %mapSystem )
#{
#  @count = split(",",$mapSystem{$key});
#  if( @count > 1 ) {
#      print OUT "$key\t$mapSystem{$key}\tMulti-Email\n";
#  }
#  else {
#      print OUT "$key\t$mapSystem{$key}\n";
#  }
#}
#close(OUT);

open(OUT, ">$home/data/ownerTags/keyNameMappings.dat") or die "Can't open file";
print OUT "keyname\towner\n";
foreach my $key ( keys %mapKeyName )
{
  @count = split(",",$mapKeyName{$key});
  if( @count > 1 ) {
      print OUT "$key\t$mapKeyName{$key}\tMulti-Email\n";
  }
  else {
      print OUT "$key\t$mapKeyName{$key}\n";
  }
}
close(OUT);

sub processFile {
    <IN>; # skip header
    while (<IN>) {
        chomp;
        ($InstanceId, $State, $KeyName, $Name, $group, $system, $owner) = split("\t");
        if( $owner ne "None" ) {
            #if( $system ne "None" ) {
            #    if( $mapSystem{$system} ne "" ) {
            #        if( $mapSystem{$system} ne $owner ) {
            #            $mapSystem{$system} .= ",$owner";
            #        }
            #    }
            #    else {
            #        $mapSystem{$system} = $owner;
            #    } 
            #} 
            if( $KeyName ne "None" ) {
                if( $mapKeyName{$KeyName} ne "" ) {
                    if( $mapKeyName{$KeyName} ne $owner ) {
                        $mapKeyName{$KeyName} .= ",$owner";
                    }
                }
                else {
                    $mapKeyName{$KeyName} = $owner;
                } 
            } 
        } 
    }
    close(IN);
}
