#!/usr/bin/perl -w

use strict;

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'JavaScript::Lint',
    VERSION_FROM  => 'lib/JavaScript/Lint.pm',
    PREREQ_PM     => { JavaScript => 0, },
    ABSTRACT_FROM => 'lib/JavaScript/Lint.pm',
    AUTHOR        => 'Dominic Mitchell <dom@happygiraffe.net>',
);
