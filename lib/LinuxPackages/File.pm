package LinuxPackages::File;

use strict;
use warnings;

use FindBin;

my $DIR_DATA = "$FindBin::Bin/../data";

=head1 FUNCTIONS

=head2  Search_DEB($distrib, $release, $arch, $pattern)

=cut

sub Search_DEB
{
    my ($distrib, $release, $arch, $pattern) = @_;
    my @list = ();
    
    if (defined open my $DATA, '-|', "zcat $DIR_DATA/$distrib/$release/Contents-${arch}.gz")
    {
        while (<$DATA>)
    	{
    	   if (my ($file, $pkg_list) = $_ =~ /^(\S+)\s+(\S+)$/)
            {
    	       if ($file =~ /$pattern/)
    			{
    			     foreach my $pkg (split /,/, $pkg_list)
    			     {
    			         push @list, { distribution => $distrib, 
    			         	distribution_release => $release,
    			         	file => $file, package => $pkg };
    			     }
    			}
            }
    	}
    	close $DATA;
    }
    
    return ( \@list );   
}


=head2  Search_RPM($distrib, $release, $arch, $pattern)

=cut

sub Search_RPM
{
    my ($distrib, $release, $arch, $pattern) = @_;  
    
    #my $conf = XMLin("$DIR_DATA/$distrib/$release/filelists.xml", ForceArray => ['package'], KeyAttr => []);
    #foreach my $pkg (@{$conf->{package}})
    #{
     #   foreach my $file (@{$pkg->{file}})
     #   {
      #  printf "File: %s\n",    $file->{content}  if ($file->{content} =~ /$search/);
            #printf "File: %s (Package %s (%s))\n", $file->{content}, $pkg->{name}, $pkg->{version}->{ver}   
            #    if ($file->{content} =~ /$search/);
            #printf "%s (%s)\n", $pkg->{name}, $pkg->{version}->{ver};  
}


=head2 Search($distribs, $releases, $arch, $pattern)

=cut

sub Search
{
    my ($distribs, $releases, $arch, $pattern) = @_;
    
    foreach my $d (@{$distribs})
    {
        foreach my $r (@{$releases})
        {           
            my $files = Search_DEB($d, $r, $arch, $pattern);
            foreach my $f (@{$files})
            {
            	printf "Distribution: %s release: %s\n\tFile: %s - Packages: %s\n", 
            	   $f->{distribution}, $f->{distribution_release},
            	   $f->{file}, $f->{package};
            }
        }
    }
    
                   
}

1;

=head1 AUTHOR

Sebastien Thebert <linuxpackages@ittool.org>

=cut