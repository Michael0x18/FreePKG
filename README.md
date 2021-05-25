# FreePKG

FreePKG is a package manager written in Perl.
It's simple, fast, and robust.
It is also decentralized, and allows for the scattering of a package tree across many different hosts.

How to build:
1) Create a system user named \_pkgbuild. How you do this depends on your operating system
2) git clone this thing
3) run freepkg_setup.pl
4) use freepkg add-repo name::protocol://site.com/path/to/pkglist.txt
5) use "freepkg install repo package" to install stuff
