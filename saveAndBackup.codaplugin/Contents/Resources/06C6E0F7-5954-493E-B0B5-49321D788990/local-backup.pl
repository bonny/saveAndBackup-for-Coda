#!/usr/bin/perl 

# Coda backup
# Pär Thernström <par.thernstrom@gmail.com>
# Bobbie Stump <bobbie.stump@gmail.com>
#
# History
# - April 15, 2009 (Pär): first version. Seems to work!
# - November 06, 2009 (Bobbie): Saves files in local folder, new subfolder
#   for each day (for easier sorting)!  =)
#
# Some debug-things:
# print all env-variables
# foreach (sort keys %ENV) {
#	print "$_  =  $ENV{$_}\n";
#}

# get whole document from stdin
@doc = <STDIN>;
$doc = join('', @doc);

# get filename of current file
@filepath = split(/\//, $ENV{'CODA_FILEPATH'});
$filename = pop(@filepath);

# get a date to prefix with
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time);
$time = sprintf "%02d_%02d_%02d", $hour,$min,$sec;
$today = sprintf "%4d-%02d-%02d", $year+1900,$mon+1,$mday;

# where to save the backup
$sitepath = $ENV{'CODA_SITE_LOCAL_PATH'};
# Empty or like this /Volumes/MacBook/Users/bonny/Dropbox/Webb/VPS, eskapism.se/coda local root
if (length($sitepath) == 0) {
	# no sitepath exists, save in user home folder + todays date
	$saveDir = $ENV{'HOME'} . "/coda_backups/" . $today;
	$savePathAndName = $saveDir . "/" . $time . "_" . $filename;
} else {
	# sitepath exists, save in the folder of the local root
	$saveDir = $sitepath . "/coda_backups/";
	mkdir "$saveDir", 0777 unless -d "$saveDir";
	$saveDir = $sitepath . "/coda_backups/" . $today;
	$savePathAndName = $saveDir . "/" . $time . "_" . $filename;
}

print "\nSaving backup to:\n" . $savePathAndName;

# make sure backup dir exists
mkdir "$saveDir", 0777 unless -d "$saveDir";

# create and write to file
open FILE, ">$savePathAndName" or die $!;
print FILE $doc;
close FILE;
