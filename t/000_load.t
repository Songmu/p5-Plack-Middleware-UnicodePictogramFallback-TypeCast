#!perl -w
use strict;
use Test::More tests => 1;

BEGIN {
    use_ok 'Plack::Middleware::PictgramFallback::TypeCast';
}

diag "Testing Plack::Middleware::PictgramFallback::TypeCast/$Plack::Middleware::PictgramFallback::TypeCast::VERSION";
