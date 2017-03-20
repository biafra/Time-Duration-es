package Time::Duration::es;
use strict;
use warnings;

our $VERSION = '0.01';

use base qw(Exporter);
our @EXPORT = qw( later later_exact earlier earlier_exact
                  ago ago_exact from_now from_now_exact
                  duration duration_exact concise );
our @EXPORT_OK = ('interval', @EXPORT);

use constant DEBUG => 0;
use Time::Duration qw();

sub concise ($) {
    my $string = $_[0];
    # print "in : $string\n";
    $string =~ tr/,//d;
    $string =~ s/\by\b//;
    $string =~ s/\b(año|día|hora|minuto|segundo)s?\b/substr($1,0,1)/eg;
    $string =~ s/\s*(\d+)\s*/$1/g;

    # dirty hack to restore prefixed intervals
    $string =~ s/daqui a/daqui a /;

    return $string;
}

sub later {
    interval(      $_[0], $_[1], '%s antes', '%s después',  'ahora'); }
sub later_exact {
    interval_exact($_[0], $_[1], '%s antes', '%s después',  'ahora'); }
sub earlier {
    interval(      $_[0], $_[1], '%s después', '%s antes',  'ahora'); }
sub earlier_exact {
    interval_exact($_[0], $_[1], '%s después', '%s antes',  'ahora'); }
sub ago {
    interval(      $_[0], $_[1], 'daqui a %s', '%s atrás', 'ahora'); }
sub ago_exact {
    interval_exact($_[0], $_[1], 'daqui a %s', '%s atrás', 'ahora'); }
sub from_now {
    interval(      $_[0], $_[1], '%s atrás', 'daqui a %s', 'ahora'); }
sub from_now_exact {
    interval_exact($_[0], $_[1], '%s atrás', 'daqui a %s', 'ahora'); }



sub duration_exact {
    my $span = $_[0];   # interval in seconds
    my $precision = int($_[1] || 0) || 2;  # precision (default: 2)
    return '0 segundos' unless $span;
    _render('%s',
        Time::Duration::_separate(abs $span));
}

sub duration {
    my $span = $_[0];   # interval in seconds
    my $precision = int($_[1] || 0) || 2;  # precision (default: 2)
    return '0 segundos' unless $span;
    _render('%s',
        Time::Duration::_approximate($precision,
            Time::Duration::_separate(abs $span)));
}

sub interval_exact {
    my $span = $_[0];                      # interval, in seconds
                                         # precision is ignored
    my $direction = ($span <= -1) ? $_[2]  # what a neg number gets
                  : ($span >=  1) ? $_[3]  # what a pos number gets
                  : return          $_[4]; # what zero gets
    _render($direction,
        Time::Duration::_separate($span));
}

sub interval {
    my $span = $_[0];                      # interval, in seconds
    my $precision = int($_[1] || 0) || 2;  # precision (default: 2)
    my $direction = ($span <= -1) ? $_[2]  # what a neg number gets
                  : ($span >=  1) ? $_[3]  # what a pos number gets
                  : return          $_[4]; # what zero gets
    _render($direction,
        Time::Duration::_approximate($precision,
            Time::Duration::_separate($span)));
}

my %en2es = (
    second => ['segundo', 'segundos'],
    minute => ['minuto' , 'minutos' ],
    hour   => ['hora'   , 'horas'   ],
    day    => ['día'    , 'días'    ],
    year   => ['año'    , 'años'    ],
);

sub _render {
    # Make it into Spanish
    my $direction = shift @_;
    my @wheel = map
    {
        (  $_->[1] == 0) ? ()  # zero wheels
             : $_->[1] . ' ' . $en2es{ $_->[0] }[ $_->[1] == 1 ? 0 : 1 ]
        }

    @_;

    return 'ahora' unless @wheel; # sanity
    my $result;
    if(@wheel == 1) {
        $result = $wheel[0];
    } elsif(@wheel == 2) {
        $result = "$wheel[0] y $wheel[1]";
    } else {
        $wheel[-1] = "y $wheel[-1]";
        $result = join q{, }, @wheel;
    }
    return sprintf($direction, $result);
}

1;
__END__

=head1 NAME

Time::Duration::es - describe Time duration in Spanish

=head1 SYNOPSIS

  use Time::Duration::es;

  my $duration = duration(time() - $start_time);


=head1 DESCRIPTION

Time::Duration::es is a Spanish localized version of Time::Duration.
Check L<Time::Duration> for all the functions.

=head1 AUTHOR

Paulo A Ferreira E<lt>biafra@cpan.orgE<gt>

All code was taken from Time::Duration::pt which most of its code was taken
from Time::Duration::sv by Arthur Bergman and Time::Duration by Sean M. Burke.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Time::Duration> and L<Time::Duration::Locale>

