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
foreach my $arg (@ARGV){
	#Fetch list of trees
	#Iterate over trees
	foreach my $tree (<'/opt/FreePKG/tree/*'>) {
		if(-d $tree){
			foreach my $category (<"$tree/*">){
				if(-d $category){
					if(-d "$category/$arg"){
						goto end;
					}
				}
			}
		}
	}
	print(color('bold red') . "[ERROR] " . color('reset') . "Could not locate package $arg\n");
	exit(1);
	end:
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
