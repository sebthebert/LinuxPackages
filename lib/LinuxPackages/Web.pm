package LinuxPackages::Web;
use Dancer ':syntax';

use FindBin;
use lib "$FindBin::Bin/../lib/";

use LinuxPackages::Distribution;

our $VERSION = '0.1';

get '/' => sub 
{
	my @distributions = LinuxPackages::Distribution::List();

    template 'about', { distributions => \@distributions };
};

=head2 Documentation
=cut

get '/documentation' => sub {
    template 'documentation';
};

=head2 Statistics
=cut

get '/statistics/' => sub {
    template 'statistics';
};

get '/statistics/:distribution' => sub {
    template 'statistics';
};

true;
