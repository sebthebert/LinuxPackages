package LinuxPackages::Distribution::Ubuntu;

use strict;
use warnings;

my $DISTRIB = 'Ubuntu';

our %PARAM = (
	color => 'orange',
	pkg_files => [ qw/main multiverse restricted universe/ ],
	url_archive => 'http://archive.ubuntu.com/ubuntu/dists',
	);

=head1 FUNCTIONS

=head2 File_list($release, $arch)

=cut

sub File_list
{
	my ($release, $arch) = @_;
	my @list = ();
	my @pkg_files = @{$PARAM{pkg_files}};

	push @list, "$release/Contents-${arch}.gz";
	foreach my $content (@pkg_files)
	{
		push @list, "$release/$content/binary-$arch/Packages.gz"; 
	} 
	push @list, "$release/Release";

	return (@list);	
}

1;
