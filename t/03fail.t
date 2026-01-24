use strict;
use warnings;
use Test::More;

use Config::INI::Reader::Multiline;

my @fail = (    # input, expected error, message
    [
        'bloop bap bang_eth',
        qr/Syntax error at line 1: 'bloop bap bang_eth'/i,
        'syntax error (no = sign)'
    ],
    [
        <<~ 'INI',
        [ flrbbbbb\
          thunk]
        whap = z_zwap   glipp
        INI
        qr/Syntax error at line 2: '  thunk]\n'/i,
        'no continuation in section headers',
    ],

);

for my $test (@fail) {
    my ( $input, $expected, $message ) = @$test;
    eval { Config::INI::Reader::Multiline->read_string($input); };
    like( $@, $expected, $message );
}

done_testing;
