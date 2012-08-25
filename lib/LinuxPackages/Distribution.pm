package LinuxPackages::Distribution;

use strict;
use warnings;

use File::Path qw(make_path);
use HTTP::Request;
use LWP::UserAgent;

use LinuxPackages::Distribution::Debian;
use LinuxPackages::Distribution::Ubuntu;

my $DIR_DATA = "$FindBin::Bin/../data";

my %DISTRIBUTION = (
    CentOS => { 
        color => 'blue',
        pkg_files => [ qw/filelists.xml.gz primary.xml.gz other.xml.gz/ ],    
        url_archive => 'http://vault.centos.org/', 
        },
    Fedora => { 
        color => 'blue',
        pkg_files => [ qw/filelists.xml.gz primary.xml.gz other.xml.gz/ ],    
        url_archive => 'http://archives.fedoraproject.org/pub/archive/fedora/linux/releases', 
        },
    );

=head1 FUNCTIONS

=head2 Download_File($src, $dst)

=cut

sub Download_File
{
    my ($src, $dst) = @_;
    
    my $ua = LWP::UserAgent->new;  
    $ua->env_proxy;
    printf "Downloading file '%s' to '%s'...\n", $src, $dst;
    my $request = HTTP::Request->new(GET => $src);
    my $response = $ua->request($request, $dst);
    printf "\t==> %s\n",  ($response->is_success ? 'OK' : 'FAILED');	
}


=head2 Download_From_Archive($distrib, $release, $arch, $dest)

=cut

sub Download_From_Archive
{
    my ($distrib, $release, $arch, $dest) = @_;
    
    if ($distrib eq 'CentOS')
    {
		my $url_archive = $DISTRIBUTION{$distrib}->{url_archive};
    	my @pkg_files = @{$DISTRIBUTION{$distrib}->{pkg_files}};	
        foreach my $file (@pkg_files)
        {
            Download_File("$url_archive/$release/os/$arch/repodata/$file", 
                "$dest/$distrib/$release/$file");
        }            
    }
	elsif ($distrib eq 'Debian')
	{
		make_path("$dest/$distrib/$distrib-$release/");
		my @file_list = LinuxPackages::Distribution::Debian::File_list(
			$release, $arch);
		my $url_archive = $LinuxPackages::Distribution::Debian::PARAM{url_archive};
		foreach my $f (@file_list)
		{
			Download_File("$url_archive/$f", "$dest/$distrib/$f");
		}
	}
    elsif ($distrib eq 'Fedora')
    { # Bug with Fedora 11,12,13
      # http://archives.fedoraproject.org/pub/archive/fedora/linux/releases/11/Fedora/i386/os/repodata/36af1d88214b770fd3d814a5126083b8e808510c76acfdc3a234d6f7e43c2425-primary.xml.gz
		my $url_archive = $DISTRIBUTION{$distrib}->{url_archive};
        my @pkg_files = @{$DISTRIBUTION{$distrib}->{pkg_files}};
        foreach my $file (@pkg_files)
        {
            Download_File("$url_archive/$release/$distrib/$arch/os/repodata/$file", 
                "$dest/$distrib/$release/$file");
        }            
    }
    elsif ($distrib =~ /Ubuntu/)
    {
		make_path("$dest/$distrib/$release/");
		my @file_list = LinuxPackages::Distribution::Ubuntu::File_list(
            $release, $arch);
    	my $url_archive = $LinuxPackages::Distribution::Ubuntu::PARAM{url_archive};
        foreach my $f (@file_list)
        {
            Download_File("$url_archive/$f", "$dest/$distrib/$f");
        }    
    }   	
}


=head2 Info($distrib, $release)

=cut

sub Info
{
    my ($distrib, $release) = @_;
    my %info = (distribution => $distrib, release_number => $release);
    
    my $file_release = "$DIR_DATA/$distrib/$release/Release";
    if (open my $fh, '<', $file_release)
    {
        while (<$fh>)
        {
            $info{date} = $1                            if ($_ =~ /^Date: (.+)\s*$/);
            $info{release_name} = $1                    if ($_ =~ /^Codename: (.+)\s*$/);
            $info{architectures} = [ split(" ", $1) ]   if ($_ =~ /^Architectures: (.+)\s*$/);           
        }
        close $fh;
    }
    
    return (%info);          
}

sub List
{
	opendir(my $dir, $DIR_DATA);
	my @distributions = grep { !/^\./ && -d "$DIR_DATA/$_" } readdir($dir);

	return (sort @distributions);
}

1;

=head1 AUTHOR

Sebastien Thebert <linuxpackages@ittool.org>

=cut
