#!env perl

use utf8;
use strict;
use warnings;

use MongoDB;
use MongoDB::OID;

my $db = MongoDB::Connection->new();

my $translations = $db->tm->tos->find( { 'area' => 'code' } );

my $language_base = "de";

while ( my $to = $translations->next ) {

    my $base_finished = ( grep { $_->{version} == $to->{ "version_finished_" . $language_base } } @{ $to->{translations}{$language_base} } )[0];

    foreach my $lang (qw/en fr pt es it nl/) {

        if ( exists $to->{"version_finished_".$lang} &&  $to->{ "version_finished_" . $lang } > 0 ) {

            my $finished = ( grep { $_->{version} == $to->{ "version_finished_" . $lang } } @{ $to->{translations}{$lang} } )[0];

            my $m_finished = $finished->{source}{string};

            if ( defined $m_finished && $m_finished eq "" ) {

                print $base_finished->{source}{string} . " ist noch nicht für $lang übersetzt\n";

                my $unset = {

                    "version_rely_on_$lang"  => 1,
                    "version_finished_$lang" => 1,
                };

                my $set = {

                    "finish_$lang" => 0,
                };

                $db->tm->tos->update(

                    { reference => $to->{reference}[0] },
                    { '$unset'  => $unset, '$set' => $set },
                    {
                        "upsert"   => 0,
                        "multiple" => 0,
                        safe       => 1,
                    }

                );

            }

        } else {

            print $to->{reference}[0] . " noch garnicht fertig\n";
        }
    }

}

__END__

  


    }



}

1;
