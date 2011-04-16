#!/usr/bin/env perl
use strict;

use FindBin qw($Bin);

use lib "lib";

use Plack::Builder;
use Plack::App::Proxy;

my $proxy = Plack::App::Proxy->new->to_app;



builder {
    #enable "Proxy::Connect";
    enable "vCursor";
    enable "Static", path => qr{^/vcursor/}, root => 'root/';
    enable sub {
        my ($app, $env) = @_;
 
        if ( $env->{REQUEST_URI} !~ /vcursor/ ) {

            return sub {

                my $env = shift;

                ( $env->{'plack.proxy.url'} = $env->{REQUEST_URI} ) =~ s|^/||;
                $proxy->($env);

            };

        } else {
            
            $app->app->($env);
        }
    };

};

