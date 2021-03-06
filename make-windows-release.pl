#!/usr/bin/perl
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
my $datestr = sprintf("%04u%02u%02u-%02u%02u%02u",$year+1900,$mon+1,$mday,$hour,$min,$sec);
my $zipname = "dosbox-x-windows-$datestr.zip";

my $ziptool = "vs2015/tool/zip.exe";

exit 0 if -f $zipname;

die unless -f $ziptool;

my $subdir="release/windows";

my $brancha=`git branch`;
my $branch;

my @a = split(/\n/,$brancha);
for ($i=0;$i < @a;$i++) {
	my $line = $a[$i];
	chomp $line;

	if ($line =~ s/^\* +//) {
		$branch = $line;
	}
}

if ( "$branch" eq "develop-win-sdl1-async-hack-201802" ) {
    $subdir="release/windows-async";
}

mkdir "release" unless -d "release";
mkdir "$subdir" unless -d "$subdir";

die "bin directory not exist" unless -d "bin";

print "$zipname\n";

my @filelist = ();

my @platforms = ('Win32', 'x64');
my @builds = ('Release', 'Release SDL2');
my @files = ('dosbox.reference.conf', 'dosbox-x.exe', 'FREECG98.bmp', 'changelog.txt');

foreach $platform (@platforms) {
	foreach $build (@builds) {
		foreach $file (@files) {
			$addfile = "bin/$platform/$build/$file";
			die "Missing file $addfile" unless -e $addfile;

			push(@filelist, $addfile);
		}
	}
}

# do it
$r = system($ziptool, '-9', "$subdir/$zipname", @filelist);
exit 1 unless $r == 0;
