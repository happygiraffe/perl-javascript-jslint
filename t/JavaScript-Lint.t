#!/usr/bin/perl -w

use strict;

use Data::Dumper;
use Test::More tests => 6;

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
                'character' => 14,
                'evidence'  => 'var two = 1+1',
                'id'        => '(error)',
                'line'      => 1,
                'reason'    => "Missing ';'"
            }
        ],
    },
    {
        name   => 'missing semicolon and late declaration',
        js     => 'two = 1+1;var two',
        errors => [
            {
                'character' => 15,
                'evidence'  => 'two = 1+1;var two',
                'id'        => '(error)',
                'line'      => 1,
                'reason'    => 'Var two was used before it was declared.'
            },
            {
                'character' => 15,
                'evidence'  => 'two = 1+1;var two',
                'id'        => '(error)',
                'line'      => 1,
                'reason'    => "Identifier 'two' already declared as global"
            },
            {
                'character' => 18,
                'evidence'  => 'two = 1+1;var two',
                'id'        => '(error)',
                'line'      => 1,
                'reason'    => "Missing ';'"
            }
        ],
    },
    {
        name   => 'nested comment, like prototype.js',
        js     => "/* nested\n/* comment */",
        errors => [
            {
                'character' => 1,
                'evidence'  => '/* nested',
                'id'        => '(error)',
                'line'      => 1,
                'reason'    => 'Nested comment.'
            },
            {
                # character, line, evidence should all be copied from previous
                # err.
                'character' => 1,
                'evidence'  => '/* nested',
                'id'        => '(fatal)',
                'line'      => 1,
                'reason'    => 'Cannot proceed.'
            }
        ],
    }
);

foreach my $t ( @tests ) {
    my @got = jslint( $t->{ js } );
    is_deeply( \@got, $t->{ errors }, $t->{ name } )
      or diag(
        Data::Dumper->new( [ \@got ], ['*errors'] )->Indent( 1 )->Sortkeys( 1 )
          ->Dump );
}

# vim: set ai et sw=4 syntax=perl :
