package LinuxPackages::Distribution;

use strict;
use warnings;

use HTTP::Request;
use LWP::UserAgent;

my %DISTRIBUTION = (
    CentOS => { 
        color => 'blue',
        pkg_files => [ qw/filelists.xml.gz primary.xml.gz other.xml.gz/ ],    
        url_archive => 'http://archives.fedoraproject.org/pub/archive/fedora/linux/releases', 
        },
    Debian => { 
    	color => 'pink',
    	pkg_files => [ qw/contrib main non-free/ ],    
    	url_archive => 'http://archive.debian.org/debian/dists', 
        },
    Fedora => { 
        color => 'blue',
        pkg_files => [ qw/filelists.xml.gz primary.xml.gz other.xml.gz/ ],    
        url_archive => 'http://archives.fedoraproject.org/pub/archive/fedora/linux/releases', 
        },
    Ubuntu => { 
    	color => 'orange',
    	pkg_files => [ qw/main multiverse restricted universe/ ],
    	url_archive => 'http://archive.ubuntu.com/ubuntu/dists', 
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
    printf "Downloading file '%s'...\n", $src;
    my $request = HTTP::Request->new(GET => $src);
    my $response = $ua->request($request, $dst);
    printf "\t==> %s\n",  ($response->is_success ? 'OK' : 'FAILED');	
}


=head2 Download_From_Archive($distrib, $release, $arch, $dest)

=cut

sub Download_From_Archive
{
    my ($distrib, $release, $arch, $dest) = @_;
    
    my $url_archive = $DISTRIBUTION{$distrib}->{url_archive};
    my @pkg_files = @{$DISTRIBUTION{$distrib}->{pkg_files}};
    
    `mkdir -p "$dest/$distrib/$release/"`;
    if ($distrib eq 'CentOS')
    {
        foreach my $file (@pkg_files)
        {
            Download_File("$url_archive/$release/os/$arch/repodata/$file", 
                "$dest/$distrib/$release/$file");
        }            
    }
    elsif ($distrib eq 'Fedora')
    { # Bug with Fedora 11,12,13
      # http://archives.fedoraproject.org/pub/archive/fedora/linux/releases/11/Fedora/i386/os/repodata/36af1d88214b770fd3d814a5126083b8e808510c76acfdc3a234d6f7e43c2425-primary.xml.gz
        foreach my $file (@pkg_files)
        {
            Download_File("$url_archive/$release/$distrib/$arch/os/repodata/$file", 
                "$dest/$distrib/$release/$file");
        }            
    }
    elsif ($distrib =~ /(Debian|Ubuntu)/)
    {
        Download_File("$url_archive/$release/Contents-${arch}.gz", 
            "$dest/$distrib/$release/Contents-${arch}.gz");
        foreach my $content (@pkg_files)
        {
            Download_File("$url_archive/$release/$content/binary-$arch/Packages.gz", 
                "$dest/$distrib/$release/Packages_${content}-${arch}.gz");
        }
        Download_File("$url_archive/$release/Release", 
            "$dest/$distrib/$release/Release");
    }   	
}

1;