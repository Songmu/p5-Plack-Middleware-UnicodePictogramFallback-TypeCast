package Plack::Middleware::PictgramFallback::TypeCast;
use 5.008_001;
use strict;
use warnings;

our $VERSION = '0.01';

use Plack::Util;
use Plack::Middleware::PictgramFallback::TypeCast::EmoticonMap;
use Encode qw/encode_utf8 decode/;
use Encode::JP::Mobile ':props';
use Encode::JP::Mobile::UnicodeEmoji;

use parent 'Plack::Middleware';
use Plack::Util::Accessor qw(
    template
);

sub prepare_app {
    my $self = shift;

    die 'requires template' unless $self->template;
}

sub call {
    my ($self, $env) = @_;
    my $res = $self->app->($env);

    my $h = Plack::Util::headers($res->[1]);
    return $res if $h->get('Content-Type') !~ m!^text/!;

    if (ref($res) && ref($res) eq 'ARRAY') {
        my $html = $res->[2][0];
        $html = $self->_filter($html);
        $res->[2][0] = $html;
        return $res;
    }
    else {
        $self->response_cb($res, sub {
            my $res = shift;
            return sub {
                my $chunk = shift;
                return unless defined $chunk;

                $self->_filter($chunk);
            };
        });
    }
}

sub _filter {
    my ($self, $html) = @_;
    $html = decode('x-utf8-jp-mobile-unicode-emoji', $html );
    my $emoticon_map = Plack::Middleware::PictgramFallback::TypeCast::EmoticonMap::MAP;

    $html =~ s{(\p{InMobileJPPictograms})}{
        my $char = $1;
        my $code = sprintf '%X', ord $char;

        if (my $name = $emoticon_map->{$code}) {
            sprintf $self->template, $name, $char;
        } else {
            $char;
        }
    }ge;

    encode_utf8 $html;
}

1;
__END__

=head1 NAME

Plack::Middleware::PictgramFallback::TypeCast - Perl extention to do something

=head1 VERSION

This document describes Plack::Middleware::PictgramFallback::TypeCast version 0.01.

=head1 SYNOPSIS

    use Plack::Middleware::PictgramFallback::TypeCast;

=head1 DESCRIPTION

# TODO

=head1 INTERFACE

=head2 Functions

=head3 C<< hello() >>

# TODO

=head1 DEPENDENCIES

Perl 5.8.1 or later.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 SEE ALSO

L<perl>

=head1 AUTHOR

Masayuki Matsuki E<lt>y.songmu@gmail.comE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2013, Masayuki Matsuki. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
