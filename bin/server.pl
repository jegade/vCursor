#!/usr/bin/env perl
use strict;

use FindBin qw($Bin);

use lib "lib";

use Plack::Builder;
use Plack::App::Proxy;

builder {
    enable "Proxy::Connect";
    enable "vCursor";
    enable sub {
        my $app = shift;
        return sub {
            my $env = shift;
            ( $env->{'plack.proxy.url'} = $env->{REQUEST_URI} ) =~ s|^/||;
            $app->($env);
        };
    };

    Plack::App::Proxy->new->to_app;
};

