#!/usr/bin/perl
#FreePKG bootstrap script v1.0
#Michael0x18

#Use
use Term::ANSIColor;
use Time::HiRes qw(usleep nanosleep);
#No buffering
$|=1;

#
print("Checking permissions...\n");

#if($>!=0){
#	print(color('bold red'));
#	print("[ERROR] " );
#	print(color('reset'));
#	print("Insufficient permissions: are you root?\n");
#	exit(1);
#}
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
print("Checking for existing FreePKG installation...\n");
if(-e '/opt/FreePKG/'){
	print(color('bold red'));
	print('[ERROR] ');
	print(color('reset'));
       	print("Directory /opt/FreePKG/ contains an existing FreePKG installation.\n");
	print("Please remove it before continuing.\n");
	exit(1);
}
print("Generating directory structure...\n");
mkdir("/opt/FreePKG",700);
mkdir("/opt/FreePKG/core",700);
mkdir("/opt/FreePKG/etc",700);
mkdir("/opt/FreePKG/tree",700);
print("Bootstrapping into /opt/FreePKG/core\n");
system("cp ./freepkg/* /opt/FreePKG/core/");
print("Done bootstrapping.\n");
print("Creating symlinking core scripts into /usr/bin...\n");
system("ln -s /opt/FreePKG/core/freepkg-bootstrap.pl /usr/bin/freepkg-bootstrap");
system("ln -s /opt/FreePKG/core/freepkg-install.pl /usr/bin/freepkg-install");
system("ln -s /opt/FreePKG/core/freepkg-search.pl /usr/bin/freepkg-search");
system("ln -s /opt/FreePKG/core/freepkg-info.pl /usr/bin/freepkg-info");
system("ln -s /opt/FreePKG/core/freepkg-remove.pl /usr/bin/freepkg-remove");
system("ln -s /opt/FreePKG/core/freepkg-manage.pl /usr/bin/freepkg-manage");
print("Finished creating symlinks.\n");
print("Cloning default package tree...\n");
chdir("/opt/FreePKG/tree/");
system("git clone https://github.com/Michael0x18/master.git");
print("Finished cloning package tree 'master' into /opt/FreePKG/tree/\n");
print(color('bold blue'));
print("Installation finished\n");
