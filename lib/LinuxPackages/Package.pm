package LinuxPackages::Package;

use strict;
use warnings;

use FindBin;

my $DIR_DATA = "$FindBin::Bin/../data";

my %package = ();
my %priority = ();
my %section = ();
my $pkg = undef;

=head1 FUNCTIONS

=head2 Search($distribs, $releases, $arch, $pattern)

=cut

sub Search
{
    my ($distribs, $releases, $arch, $pattern) = @_;
    	
    foreach my $d (@{$distribs})
    {
    	foreach my $r (@{$releases})
    	{
            my @pkg_files = glob("$DIR_DATA/$d/$r/Packages_*-${arch}.gz");
            foreach my $file_pkg (@pkg_files)
            {
            	#printf "File: %s\n", $file_pkg;
                if (defined open my $DATA, '-|', "zcat $file_pkg")
                {
                    while (<$DATA>)
                    {
                        $pkg = $1   if ($_ =~ /Package: (\S+)/);
                        $package{$d}{$r}{$pkg}{version} = $1   if ($_ =~ /Version: (\S+)/);
                        if ($_ =~ /Priority: (\S+)/)
                        {
                            $package{$d}{$r}{$pkg}{priority} = $1;
                            $priority{$d}{$r}{$1}++;
                        }
                        if ($_ =~ /Section: (\S+)/)
                        {
                            $package{$d}{$r}{$pkg}{section} = $1;
                            $section{$d}{$r}{$1}++;
                        }
                    }
                    close $DATA;
                }	
            }
        }
    }
    
    my @list = ();
    foreach my $d (keys %package)
    {
    	foreach my $r (keys %{$package{$d}})
    	{
            foreach my $k (keys %{$package{$d}{$r}})
            {
        	push @list, { distribution => $d, 'distribution_release' => $r,
        		name => $k, priority => $package{$d}{$r}{$k}{priority}, 
        		section => $package{$d}{$r}{$k}{section}, version => $package{$d}{$r}{$k}{version} }
        	   if ($k =~ /$pattern/);
            }
    	}
    }
    
    return ( \@list );
}

1;

=head1 AUTHOR

Sebastien Thebert <linuxpackages@ittool.org>

=cut
