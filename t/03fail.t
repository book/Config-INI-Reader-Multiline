use strict;
use warnings;
use Test::More;

use Config::INI::Reader::Multiline;

plan tests => 1;

{
    my $input = 'bloop bap bang_eth';
    eval { Config::INI::Reader::Multiline->read_string($input); };
    like( $@, qr/Syntax error at line 1: '$input'/i, 'syntax error' );
}
