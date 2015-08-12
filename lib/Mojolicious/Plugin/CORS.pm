package Mojolicious::Plugin::CORS;
use Mojo::Base 'Mojolicious::Plugin';

my %defaults = (
    allow_origin	=> [qw/*/],
    allow_methods	=> [qw/GET PUT POST DELETE OPTIONS/],
    max_age		=> [qw/600/],
    allow_headers	=> [qw/Content-Type Authorization X-Requested-With/],
);

sub register {
    my %heders = %defaults;
    my ( $self, $app, $opts ) = @_;

    for my $key(keys %defaults) {
        if(substr($key, 0, 1) eq "+") {
            substr($key, 0, 1) = "";
            push $headers{$key}, @{ ref $opts->{$key} eq "ARRAY" ? $opts->{$key} : [$opts->{$key}] };
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
