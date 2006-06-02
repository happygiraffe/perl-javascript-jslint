#!/usr/bin/perl -w

use strict;

use Data::Dumper;
use Test::More tests => 4;

BEGIN {
    use_ok( 'JavaScript::Lint' );
}

eval { jslint() };
like( $@, qr/usage/, 'jslint() provokes usage message' );

my @tests = (
    {
        name   => 'basic',
        js     => 'var two = 1+1;',
        errors => [],
    },
    {
        name   => 'missing semicolon',
        js     => 'var two = 1+1',
        errors => [
            {
                'character' => 13,
                'evidence'  => 'var two = 1+1',
                'id'        => '(error)',
                'line'      => 0,
                'reason'    => "Missing ';'"
            }
        ],
    },
);

foreach my $t ( @tests ) {
    my @got = jslint( $t->{ js } );
    is_deeply( \@got, $t->{ errors }, $t->{ name } )
        or diag(
        Data::Dumper->new( [ \@got ], ['*errors'] )->Indent( 1 )->Sortkeys( 1 )
            ->Dump );
}

# vim: set ai et sw=4 syntax=perl :
