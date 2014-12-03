package Act::INI;

use strict;
use Config::INI::Reader;
our @ISA = qw( Config::INI::Reader );

sub parse_value_assignment {
    my ( $self, $line ) = @_;
    return if $line =~ /\\\s*?\z/;
    $line = delete( $self->{__buffer} ) . $line
        if exists $self->{__buffer};
    return $self->SUPER::parse_value_assignment($line);
}

sub handle_unparsed_line {
    my ( $self, $handle, $line ) = @_;
    return $self->{__buffer} .= $line
        if $line =~ s/\\\s*?\z//;
    return $self->SUPER::handle_unparsed_line( $handle, $line );
}

1;
