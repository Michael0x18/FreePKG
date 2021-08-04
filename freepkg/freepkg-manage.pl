#!/usr/bin/perl
#FreePKG manage script v1.0
#Michael0x18

#Use
use Term::ANSIColor;
use Time::HiRes qw(usleep nanosleep);
#No buffering
$|=1;

#
print("Checking permissions...\n");

if($>!=0){
	print(color('bold red'));
	print("[ERROR] " );
	print(color('reset'));
	print("Insufficient permissions: are you root?\n");
	exit(1);
}
print("Permission check passed.\nChecking lock file...\n");
if(-e '/tmp/FreePKG/freepkg.lock'){
	print("Lock file /tmp/FreePKG/freepkg.lock exists, waiting...  ");
}
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
print("Check passed.\n");
print("FreePKG installation manager started.\n");
print("Press [ENTER] to remove FreePKG or ctrl-c to exit.");
<STDIN>;
print("Are you sure you want to remove the FreePKG installation? Press [ENTER] again to confirm.\n");
print(color("bold red"));
print("ALL DATA WILL BE LOST.\n");
print(color('reset'));
<STDIN>;
print("Proceeding with removal of FreePKG:\n");
print("Removing symlinks of core packages to /usr/bin");
print("rm /usr/bin/freepkg-*\n");
system("rm /usr/bin/freepkg-*");
print("executing rm -rf /opt/FreePKG/\n");
system("rm -rf /opt/FreePKG/");
print("Execution finished.\n");
