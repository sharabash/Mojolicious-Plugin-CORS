package Mojolicious::Plugin::CORS;
use Mojo::Base 'Mojolicious::Plugin';
use Clone qw/clone/;

sub register {
    my ( $self, $app, $opts ) = @_;
    my %defaults = (
        allow_origin	=> [qw/*/],
        allow_methods	=> [qw/GET PUT POST DELETE OPTIONS/],
        max_age		=> [qw/3600/],
        allow_headers	=> [qw/Content-Type Authorization X-Requested-With/],
    );

    my %headers = %{ clone \%defaults };

    for my $key(keys %$opts) {
	if(substr($key, 0, 1) eq "+") {
	    my $name = substr($key, 1);
            push @{ $headers{$name} }, @{ ref $opts->{$key} eq "ARRAY" ? $opts->{$key} : [$opts->{$key}] };
        } else {
             $headers{$key} = ref $opts->{$key} eq "ARRAY" ? $opts->{$key} : [$opts->{$key}];
        }
    }

    CORS: {
        $app->hook( before_dispatch => sub {
            my $c = shift;
	    for my $header(keys %headers) {
                $c->res->headers->header( translate_name($header) => join ", ", @{ $headers{$header} } );
	    }
        } );
    };
}

sub translate_name {
	my $name = shift;
	join "-", "Access-Control", map {ucfirst} split /_/, $name
}

1;

=head1 SYNOPSIS

    package App;
    use Mojo::Base 'Mojolicious';

    sub startup {
        my $self = shift;

        $self->plugin( 'Mojolicious::Plugin::CORS' );
    }

=cut
