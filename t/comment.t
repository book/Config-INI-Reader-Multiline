use strict;
use warnings;
use Test::More;

use Config::INI::Reader::Multiline;
use Config::INI::Reader;

my %test = (
    't/comment.ini' => {
        'section1' => {
            'name1' => 'value1 extravalue1',
            'name2' => 'value2',
        },
        'section2' => {
            'name3' => 'value3',
        },
    }
);

plan tests => scalar keys %test;

for my $ini ( sort keys %test ) {
    my $config = Config::INI::Reader::Multiline->read_file($ini);
    # diag explain $config;
    is_deeply( $config, $test{$ini}, $ini );
}

done_testing();
