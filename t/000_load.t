#!perl -w
use strict;
use Test::More tests => 1;

BEGIN {
    use_ok 'Plack::Middleware::PictogramFallback::TypeCast';
}

diag "Testing Plack::Middleware::PictogramFallback::TypeCast/$Plack::Middleware::PictogramFallback::TypeCast::VERSION";
