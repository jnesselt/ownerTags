#!/usr/bin/perl

# Print out untagged owner instances for a specific date using system and key name mapping files.
# Format for instanceId files.

my $launchTime, $InstanceId, $KeyName, $system, $owner;
my %mapSystem;
my %mapKeyName;
my $mydate = $ARGV[0];
my $environment = $ARGV[1];
my $region = $ARGV[2];
my $home = $ENV{"HOME"};

open(IN, "$home/data/ownerTags/systemMappings.dat") or die "Can't open file";
while (<IN>) {
    chomp;
    ($system, $owner) = split("\t");
    $mapSystem{$system} = $owner;
}
close(IN);

open(IN, "$home/data/ownerTags/keyNameMappings.dat") or die "Can't open file";
while (<IN>) {
    chomp;
    ($keyName, $owner) = split("\t");
    $mapKeyName{$keyName} = $owner;
}
close(IN);

open(IN, "$home/data/ownerTags/$mydate-$environment-$region-notify.dat") or die "Can't open file";
while (<IN>) {
    chomp;
    ($launchTime, $InstanceId, $KeyName, $system, $owner) = split("\t");
    if( $mapSystem{$system} ne "" ) {
        print "$region $InstanceId $mapSystem{$system}\n";
    }
    elsif( $mapKeyName{$KeyName} ne "" ) {
        print "$KeyName $region $InstanceId $mapKeyName{$KeyName}\n";
    }
    else {
        print "No Email for Instance: $InstanceId, KeyName: $KeyName, System: $system\n";
    }
}
close(IN);
