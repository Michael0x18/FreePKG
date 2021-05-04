#!/usr/bin/perl

my $version_string='FreePKG Version 0.0 DEV';

use Term::ANSIColor;
use POSIX;

#	This is the FreePKG Package manager.
#	Specifically, it's the frontend perl script that gets
#	invoked by the user.

sub setred{
	print(color('bold red'));
}

sub setblue{
	print(color('bold blue'));
}

sub setgreen{
	print(color('bold green'));
}

sub setreset{
	print(color('reset'));
}

#Check for no args and give some basic help
my $argc = @ARGV;
if($argc==0){
	setred();
	print('[ERROR] Bad Invocation' . "\n");
	setreset();
	print('freepkg [operation] [flags] [packages]' . "\n");
	exit(1);
}

#list-repos command
if(@ARGV[0] eq 'list-repos'){
	system("ls /pkg/repos");
}

#	Implementation of the add-repo command
if(@ARGV[0] eq 'add-repo'){
	#Check for only one argument and ask for other stuff
	if($argc == 1){
		print('[ERROR] Missing add-repo argument <name::url>' . "\n");
		print(color('reset'));
		print('Example: freepkg add-repo <name::repo_url> ' . "\n");
		#my $repo_name = <STDIN>;
	}else{
		#Iterate over all others, split by double colon, load stuff.
		for(my $i=1; $i < $argc; $i++){
			#Pretty print for the user
			setblue();
			print('[ADD-REPO] ');
			setreset();
			printf('Adding repo %s',@ARGV[$i]);
			print("\n");
			#Split array, discard other qualifiers
			#Argument format:
			#Reponame::repourl
			my @arr2 = split('::',@ARGV[$i]);
			my $rname = @arr2[0];
			my $rurl = @arr2[1];
			#Fetch using wget
			print 'Fetching package list from remote url' . "\n";
			my $retval=system("wget $rurl -P /pkg/repos/$rname");
			if($retval!=0){
				setred();
				print('[ERROR] ');
				setreset();
				print('Could not fetch data from repository!');
				next;
			}
			print 'Writing repo data' . "\n";
			open(FH,'>',"/pkg/repos/$rname/repodat.txt");
			print FH @ARGV[$i];
			print 'Building package tree' . "\n";
			#TODO FINISH::::::::::Read the package list and build the tree.::::::::::::::::::::>>>>>>>>>FLAG_NEEDS_WORK
			#Meh, it's almost done anyway
			open(FH,'<',"/pkg/repos/$rname/pkglist.txt");#The format will be:
			# packagename::packagerepo::description with % as line breaks::internal dependencies separated by semicolons::external dependencies separated by semicolons::keywords::executable_name_list_with_semicolons
			while(my $line = <FH>){
				#Test comment
				if(rindex($line, "#", 0) == 0){
					#ignore comments
					#print('comment, skipping' . "\n");
				}else{
					#Split by the double colon
					@tmp = split('::',$line);
					mkdir("/pkg/repos/$rname/@tmp[0]/",0755);#read/write by root, (who owns it) and read only for everyone else.
					#Write package address into address file.
					#print("Writing package data\n");
					open($FH2,'>',"/pkg/repos/$rname/@tmp[0]/pkgaddr.txt");
					print $FH2 @tmp[1] . "\n";
					close($FH2);
					#Write package information into information file.
					#print("Writing package descriptors\n");
					open($FH3,'>',"/pkg/repos/$rname/@tmp[0]/pkginfo.txt");
					my @descriptor = split('%',@tmp[2]);
					foreach(@descriptor){
						print $FH3 $_ . "\n";
					}
					close($FH3);
					#Write internal package dependency list into dependency file.
					#print("Writing internal dependencies\n");
					open($FH4,'>',"/pkg/repos/$rname/@tmp[0]/dependencies.txt");
					if(@tmp[3] ne 'null'){
						my @arr42 = split(';',@tmp[3]);
						foreach(@arr42){
							print $FH4 $_ . "\n";
						}
					}
					close($FH4);
					#Write external package dependency list into edependency file.
					#print("Writing external dependencies\n");
					open($FH5,'>',"/pkg/repos/$rname/@tmp[0]/edependencies.txt");
					foreach(split(';',@tmp[4])){
						print $FH5 $_ . "\n";
					}
					close($FH5);
					#Write search keywords into dependency file
					#print("Writing keywords \n");
					open($FH6,'>',"/pkg/repos/$rname/@tmp[0]/keywords.txt");
					foreach(split(';',@tmp[5])){
						print $FH6 $_ . "\n";
					}
					close($FH6);
					#Write executable list into execlist.txt
					#print("Writing exec list\n");
					open($FH7,'>',"/pkg/repos/$rname/@tmp[0]/execlist.txt");
					foreach(split(';',@tmp[6])){
						print $FH7 $_ . "\n";
					}
					close($FH7);
					#Don't create file "installed".					
				}
			}
			close(FH);
		}
	}
}

#	Implementation of the install command
if(@ARGV[0] eq 'install'){
	#Check for correct args
	if($argc < 3){
		setred();
		print '[ERROR] ';
		setreset();
		print 'Missing parameters. Usage: freepkg install <repo> <package>' . "\n";
		exit(1);
	}
	#first sub-arg is reponame
	my $rname = @ARGV[1];
	#Start path
	my $filepath = "/pkg/repos/$rname/";
	#Sanity check and die
	unless(-e $filepath){
		setred();
		print '[ERROR] ';
		setreset();
		print "Could not locate repo $rname, do you have it added? \n";
		exit(1);
	}
	#Iterate over all others, and install
	for(my $i=2; $i < $argc; $i++){
		my $pkgpath = $filepath . @ARGV[$i];
		#print $pkgpath . "\n";
		#Package not found
		unless(-e $pkgpath){
			setred();
			print '[ERROR] ';
			setreset();
			print "Could not locate package @ARGV[$i]; skipping install. \n";
			next;
		}else{
			#package was located
			setred();
			print "[TODO]";
			setblue();#								TODO TODO TODO TODO install stuff.
			print "This is just a reminder for me: I need to implement the actual install steps.\nThey are:\n0) resolve dependencies\n1)Download tarball from location pointed to by the package data\n2) Extract the tarball\n3)Drop privileges\n4) Run build scripts\n5)symlink binaries into /pkg/bin\n6) Update the list of installed packages -- sike user has to manually do deps";
			setreset();

				#BEGIN BUILD PROCESS

			#Create build folder
			mkdir "$pkgpath/build",0755;
			#Change permissions
			system("chown _pkgbuild $pkgpath/build");
			#Drop privileges.
			#In this case, run a subshell as an unprivileged user.
			#It's a dirty hack, but whatever.
			system("sudo -u _pkgbuild /bin/sh -c \"(cd $pkgpath/build && wget --no-cache -i $pkgpath/pkgaddr.txt -P $pkgpath/build && tar -xvf @ARGV[$i].tar.xz && cd @ARGV[$i] && sh build.sh)\"");
			#Hack finished -- subshell returns, now back at running with root privileges.
			#Time to symlink the executables into the bin folder.
			open(FH,'<',"$pkgpath/execlist.txt");
			#open list of executable files
			while(my $line = <FH>){
				if($line eq "\n"){next};
				chomp($line);
				#create symlinks in bin
				system("ln -s $pkgpath/build/@ARGV[$i]/bin/$line /pkg/bin/$line");
			}
			close(FH);
			open($FH2,'>',"$pkgpath/installed");
			print $FH2 'THIS FILE IS PRESENT IF THE PACKAGE IS INSTALLED' . "\n";
			print $FH2 "INSTALLATION MODE: MANUAL\n"
			print $FH2 "--end--\n";
			next;
		}
	}
	exit(0);
}

if(@ARGV[0] eq 'remove' or @ARGV[0] eq 'uninstall'){
	print('remove requested' . "\n");
	exit(0);
}

#updates all packages
if(@ARGV[0] eq 'upgrade'){
	print('upgrade requested' . "\n");
	exit(0);
}

#gets update status of packages
if(@ARGV[0] eq 'status'){
	print('status requested' . "\n");
	exit(0);
}

#	Get information about package
if(@ARGV[0] eq 'info'){
	if($argc<3){
		setred();
		print '[ERROR] ';
		setreset();
		print "Missing parameters. Usage: freepkg info <repo> <package>" . "\n";
		exit(1);
	}
	my $rname = @ARGV[1];
	my $filepath = "/pkg/repos/$rname/";
	unless(-e $filepath){
		setred();
		print '[ERROR] ';
		setreset();
		print "Could not locate repo $rname, do you have it added? \n";
		exit(1);
	}
	for(my $i=2; $i<$argc; $i++){
		my $pkgname = @ARGV[$i];
		my $pkgpath = $filepath . $pkgname;
		unless(-e $pkgpath){
			setred();
			print '[ERROR] ';
			setreset();
			print "Could not locate package @ARGV[$i]; skipping. \n";
			next;
		}else{
			setblue();
			print "Package $pkgname from repo $rname:\n";
			setreset();
			#I'm not going to use file handles to print the contents of a file for the user.
			#There's already a very, very good utility for that called cat.
			#If they don't have it... WTF?
			system("cat /pkg/repos/$rname/$pkgname/pkginfo.txt");
			setgreen();
			print "Internal dependencies:\n";
			setreset();
			system("cat /pkg/repos/$rname/$pkgname/dependencies.txt");
			setgreen();
			print "External dependencies:\n";
			setreset();
			system("cat /pkg/repos/$rname/$pkgname/edependencies.txt");
			setreset();
			setblue();
			print "Installed status:\n";
			if(-e $pkgpath . "/installed"){
				setgreen();
				print "Installed";
			}else{
				setred();
				print "Not Installed";
			}
			print "\n";
			setreset();
		}
	}
	exit(0);
}

if(@ARGV[0] eq '--version'){
	print(color('bold blue'));
	print($version_string . "\n");
	print(color('bold green'));
	print('The FreePKG program, its documentation, and any other auxiliary resources involved in building, installing and running the program, such as graphics, Makefiles, and user interface definition files, are licensed under the GNU General Public License version 2 or later. This includes, but is not limited to, all the files in the official source distribution, as well as the source distribution itself.

A copy of the GNU General Public License can be found in the file LICENSE in the top directory of the official source distribution. The license is also available in several formats through the World Wide Web, via http://www.gnu.org/licenses/licenses.html#GPL, or you can write the Free Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

FreePKG is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
');
	exit(0);
}

#Print some basic help
if(@ARGV[0] eq 'help'){
	print(color('bold blue'));
	print('Running FreePKG help (cmd: freepkg-help )');
	exit(0);
}
