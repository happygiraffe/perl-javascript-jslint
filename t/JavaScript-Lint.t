#!/usr/bin/perl -w

use strict;

use Data::Dumper;
use Test::More tests => 12;

BEGIN {
    use_ok( 'JavaScript::Lint' );
}

eval { jslint() };
like( $@, qr/usage/, 'jslint() provokes usage message' );

my @tests = (
    {
        name   => 'empty',
        js     => '',
        opts   => {},
        errors => [],
    },
    {
        name     => 'basic',
          js     => 'var two = 1+1;',
          opts   => {},
          errors => [],
    },
    {
        name   => 'missing semicolon',
        js     => 'var two = 1+1',
        opts   => {},
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
        opts   => {},
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
        opts   => {},
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
    },
    {
        name   => 'allow undefined variables',
        js     => 'alert(42);',
        opts   => {},
        errors => [],
    },
    {
        name   => 'disallow undefined variables',
        js     => 'alert(42);',
        opts   => { 'undef' => 1 },
        errors => [
            {
                'character' => 1,
                'evidence'  => 'alert(42);',
                'id'        => '(error)',
                'line'      => 1,
                'reason'    => 'Undefined variable: alert',
            }
        ],
    },
    {
        name   => 'random options allowed',
        js     => 'alert(42);',
        opts   => { xyzzy => 1 },
        errors => [],
    },
    {
        name   => 'embedded html',
        js     => '<html><head><script type="text/javascript">alert(42);</script></head></html>',
        opts   => {},
        errors => [],
    },
    {
        name   => 'embedded html in attribute',
        js     => '<html><body><a onclick="alert(42);">click here</a></body></html>',
        opts   => {},
        errors => [],
    },
);

foreach my $t ( @tests ) {
    my @got = jslint( $t->{ js }, %{ $t->{ opts } } );
    is_deeply( \@got, $t->{ errors }, $t->{ name } )
      or diag(
        Data::Dumper->new( [ \@got ], ['*errors'] )->Indent( 1 )->Sortkeys( 1 )
          ->Dump );
}

# vim: set ai et sw=4 syntax=perl :
