#!/usr/bin/perl -w
# @(#) $Id$

use strict;
use Module::Build;

Module::Build->new(
    module_name        => 'JavaScript::Lint',
    license            => 'bsd',
    dist_author        => 'Dominic Mitchell <cpan (at) happygiraffe.net>',
    script_files       => ['bin/jslint'],
    create_makefile_pl => 'passthrough',
    add_to_cleanup     => ['JavaScript-Lint-*'],
    requires           => {
        File::Basename => 0,
        Getopt::Long   => 0,
        JavaScript     => 0,
    },
)->create_build_script;
