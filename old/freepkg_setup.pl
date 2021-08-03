#!/usr/bin/perl

use Term::ANSIColor;

my $version_string='FreePKG Version 0.0 DEV' . "\n" . '0' . "\n" . '0';

#This perl script is designed to set up the FreePKG package manager.
#Specifically, it sets up the directory structure in the /pkg/ directory
#and puts the executables for FreePKG there.

#	Check for root user. This will be needed later.

print(color('blue'));
print "OSType: $^O\n";
if (index($^O, "MS") != -1) {
	print "Please ensure you are running FreePKG on a UNIX-like operating system. If you are not, you do so at your own risk. \n If you're running this in WSL or Cygwin, ";
	print color('bold red');
	print "THEY ARE NOT SUPPORTED!\n";
}
print (color('reset'));

if($> !=0){
	print(color('bold red'));
	print('[ERROR] ');
	print(color('reset'));
	print('Please run again as root');
	exit(1);
};

if(-e "/pkg"){
	system("rm -r /pkg");
}


print(color('bold green'));
print('FreePKG setup script' . "\n");
print('Creating directory tree' . "\n");
print('Creating directory tree...' . "\n");
print('Creating /pkg/' . "\n");
mkdir('/pkg/',0755);
print('Creating /pkg/bin/' . "\n");
mkdir('/pkg/bin/',0755);
print('Creating /pkg/core/' . "\n");
mkdir('/pkg/core/',0755);
print('Creating /pkg/repos/' . "\n");
mkdir('/pkg/core/repos',0755);
print('Creating /pig/core/bin' . "\n");
mkdir('/pkg/core/bin/',0755);
print('Creating /pkg/core/etc' . "\n");
mkdir('/pkg/core/etc/',0755);
print('Creating /pkg/car/' . "\n");
mkdir('/pkg/var/',0755);
mkdir('/pkg/repos',0755);
print('Generating FreePKG information file.');
open(FH,'>','/pkg/var/version.txt');
print(FH $version_string . "\n");
print('Finished creating base file hierarchy.' . "\n");
print('Placing executables into the tree' . "\n");
system("cp ./freepkg_setup.pl /pkg/core/bin/freepkg_setup");
system("cp ./freepkg.pl /pkg/core/bin/freepkg");
close(FH);
