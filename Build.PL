#!/usr/bin/perl -w
# @(#) $Id$

use strict;
use Module::Build;

Module::Build->new(
    module_name        => 'JavaScript::Lint',
    license            => 'bsd',
    dist_author        => 'Dominic Mitchell <cpan (at) happygiraffe.net>',
    requires           => { JavaScript => 0 },
    script_files       => ['bin/jslint'],
    create_makefile_pl => 'passthrough',
    add_to_cleanup     => ['JavaScript-Lint-*'],
)->create_build_script;
