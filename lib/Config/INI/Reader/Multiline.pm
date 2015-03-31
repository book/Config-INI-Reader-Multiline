package Config::INI::Reader::Multiline;

use strict;
use warnings;

use Config::INI::Reader 0.024;
our @ISA = qw( Config::INI::Reader );

sub parse_value_assignment {
    my ( $self, $line ) = @_;
    return if $line =~ /\\\s*?\z/;
    $line = delete( $self->{__buffer} ) . $line
        if exists $self->{__buffer};
    return $self->SUPER::parse_value_assignment($line);
}

sub handle_unparsed_line {
    my ( $self, $line, $handle ) = @_; # order changed in CIR 0.024
    return $self->{__buffer} .= $line
        if $line =~ s/\\\s*?\z//;
    return $self->SUPER::handle_unparsed_line( $line, $handle );
}

1;
