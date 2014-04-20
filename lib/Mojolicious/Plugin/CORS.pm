package Mojolicious::Plugin::CORS;
use Mojo::Base 'Mojolicious::Plugin';

sub register {
    my ( $self, $app, $opts ) = @_;
    CORS: {
        $app->hook( before_dispatch => sub {
            my $c = shift;
            $c->res->headers->header( 'Access-Control-Allow-Origin' => '*' );
            $c->res->headers->header( 'Access-Control-Allow-Methods' => 'GET, PUT, POST, DELETE, OPTIONS' );
            $c->res->headers->header( 'Access-Control-Max-Age' => 3600 );
            $c->res->headers->header( 'Access-Control-Allow-Headers' => 'Content-Type, Authorization, X-Requested-With' );
        } );
    };
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
