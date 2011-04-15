# ABSTRACT: Plack middleware to add the vCursor-JS

package Plack::Middleware::vCursor;

BEGIN {
    $Plack::Middleware::vCursor::VERSION = '0.0.1';
}

use strict;
use warnings;

=head1 NAME

Plack::Middleware::vCursor - Plack middleware 

=head1 VERSION

version 0.0.1

=head1 DESCRIPTION


=head1 SYNOPSIS

    use Plack::Builder;
    builder {
    }

=cut

use parent 'Plack::Middleware';

use Plack::Util;

use Plack::Util::Accessor qw/opt packer/;

sub call {
    my ( $self, $env ) = @_;

    if ( $env->{PATH_INFO} =~ m!^/vcursor! ) {
        return $self->files->call($env);
    }

    my $res = $self->app->($env);

    $self->response_cb(
        $res,
        sub {
            my $res     = shift;
            my $headers = Plack::Util::headers( $res->[1] );

            if ( !Plack::Util::status_with_no_entity_body( $res->[0] )
                && ( $headers->get('Content-Type') || '' ) =~ m!^(?:text/html|application/xhtml\+xml)! )
            {

                my $content = '<script>alert("Hello World");</script>';
                return sub {
                    my $chunk = shift;
                    return unless defined $chunk;
                    $chunk =~ s!(?=</body>)!$content!i;
                    return $chunk;
                };
            }
        }
    );

}

sub prepare_app {
    my $self = shift;

    #my $packer = HTML::Packer->init;
    #$self->packer($packer);
    #$self->opt({remove_newlines => 1}) unless defined $self->opt;
}

=head1 AUTHOR

    Jens Gassmann C<< <jens.gassmann@atomix.de> >>

=head1 LICENSE AND COPYRIGHT

    Copyright 2011 Jens Gassmann

=cut

1;
