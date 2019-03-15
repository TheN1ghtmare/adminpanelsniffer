use strict;
use warnings;
use 5.010;
use HTTP::Tiny;
use Switch;
use Term::ANSIColor;

my ($target, $wordlist) = @ARGV;
my ($url) = $target =~ m|^( .*?\. [^/]+ )|x;
my $Client = HTTP::Tiny->new();
my @found = ();

system("clear");
title();

if (not defined $target) {
	print "USAGE: \n\tperl adminfinder.pl {TARGET_URI} {WORDLIST}\n\n";
	exit;
}

if(not defined $wordlist) {
	$wordlist = "wordlist.txt";
}

open my $info, $wordlist or die("Error: Unable to open the file " .$wordlist);


while(my $line = <$info>) {
	$line =~ s/\R//g;
	my $url2 = "http://" . $url . "/" . $line;
	my $response = $Client->get($url2);
	switch($response->{status}) {
		case 200 {
			push(@found, $url2);
			print color("bold green");
			print $url2 . " is valid!\n";
			print color("reset");
		}
		case 403 {
			push(@found, $url2);
			print color("bold red");
			print $url2 . " is forbidden!\n";
			print color("reset");
		}
		case 500 {
			print color("red");
			print $url . " responded with internal server error!\n";
			print color("reset");
		}
		case 401 {
			push(@found, $url2);
			print color("yellow");
			print $url2 . " is asking for authentication!\n";
			print color("reset");
		}
		case 404 {
			print color("red");
			print $url2 . " not found!\n";
			print color("reset");
		}
		else {
			print color("yellow");
			print $url2 . " responded with status code: " . $response->{status} . "\n";
			print color("reset");
		}
	}
}



sub title {
	print color("magenta");
	print "#################################################\n";
	print color("yellow");
	print "#            Admin Panel Sniffer                #\n";
	print "#            Written by Nightmare               #\n";
	print color("magenta");
	print "#################################################\n";
	print color("reset");
	return;
}
