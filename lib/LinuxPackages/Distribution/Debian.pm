package LinuxPackages::Distribution::Debian;

use strict;
use warnings;

my $DISTRIB = 'Debian';

our %PARAM = (
	color => 'pink',
	pkg_files => [ qw/contrib main non-free/ ],
	url_archive => 'http://archive.debian.org/debian/dists',
	);

=head1 FUNCTIONS

=head2 File_list($release, $arch)

=cut

sub File_list
{
	my ($release, $arch) = @_;
	my @list = ();
	my @pkg_files = @{$PARAM{pkg_files}};

	#push @list, { src => "$DISTRIB-$release/Contents-${arch}.gz", dst => ;
	foreach my $content (@pkg_files)
	{
		push @list, "$DISTRIB-$release/$content/binary-$arch/Packages.gz"; 
	} 
	push @list, "$DISTRIB-$release/Release";

	return (@list);	
}

1;
