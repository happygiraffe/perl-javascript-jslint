#!/usr/bin/perl -w

use strict;

use Data::Dumper;
use Test::More tests => 5;

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
    {
        name   => 'missing semicolon and late declaration',
        js     => 'two = 1+1;var two',
        errors => [
            {
                'character' => 14,
                'evidence'  => 'two = 1+1;var two',
                'id'        => '(error)',
                'line'      => 0,
                'reason'    => 'Var two was used before it was declared.'
            },
            {
                'character' => 14,
                'evidence'  => 'two = 1+1;var two',
                'id'        => '(error)',
                'line'      => 0,
                'reason'    => "Identifier 'two' already declared as global"
            },
            {
                'character' => 17,
                'evidence'  => 'two = 1+1;var two',
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
