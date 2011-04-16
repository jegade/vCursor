#!/usr/bin/env perl
use strict;

use FindBin qw($Bin);

use lib "lib";

use Plack::Builder;
use Plack::App::Proxy;

my $proxy = Plack::App::Proxy->new->to_app;

use Plack::App::File;
use URI;


my $app = sub {
    my ( $app, $env ) = @_;

    return sub {

        my $env = shift;

        if ( $env->{REQUEST_URI} !~ /vcursor/ ) {

            # Proxy files
            ( $env->{'plack.proxy.url'} = $env->{REQUEST_URI} ) =~ s|^/||;
            $proxy->($env);

        } else {

            # Serve Special files
            my $fapp = Plack::App::File->new(root => "/www/vCursor/root");
            my $uri = URI->new($env->{PATH_INFO});
            local $env->{PATH_INFO} = $uri->path; # rewrite PATH
            $fapp->($env);
        }
      }
};

builder {

    enable "Proxy::Connect";
    enable "vCursor";
    enable $app;
    $proxy;
};

