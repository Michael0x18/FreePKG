#!/usr/bin/perl
#FreePKG install script v1.0
#Michael0x18

#Use
use Term::ANSIColor;
#use Time::HiRes;
use Time::HiRes qw(usleep nanosleep);
#No buffering
$|=1;

my $ARGC = @ARGV;

#Read packages and verify that they exist
print("Reading package database...\n");
for(my $i = 0; $i < $ARGC; $i++){
	my @trees = <'/opt/FreePKG/tree/*'>;
	foreach my $tree (@trees) {
		print $tree . "\n";
	}
}

if($>!=0){
	print(color('bold red'));
	print("[ERROR] " );
	print(color('reset'));
	print("Insufficient permissions: are you root?\n");
	exit(1);
}
my @a = ("-","\\","|","/");
my $i=0;
print("Waiting for package lock...  ");
while(-e '/tmp/FreePKG/freepkg.lock'){
	print(chr(8));
	print($a[$i]);
	$i++;
	if($i>=4){
		$i=0;
	}
	usleep(50000);
}
print(chr(8)&"\n");
