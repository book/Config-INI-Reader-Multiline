package Config::INI::Reader::Multiline;

use strict;
use warnings;

use Config::INI::Reader 0.024;
our @ISA = qw( Config::INI::Reader );

sub parse_value_assignment {
    my ( $self, $line ) = @_;
    return if $line =~ /\s*\\\s*\z/;
    $line = delete( $self->{__buffer} ) . $line
        if exists $self->{__buffer} && $line =~ s/^\s*//;
    return $self->SUPER::parse_value_assignment($line);
}

sub handle_unparsed_line {
    my ( $self, $line, $handle ) = @_; # order changed in CIR 0.024
    return $self->{__buffer} .= "$line "
        if $line =~ s/\s*\\\s*\z// && $line =~ s/\A\s*//;
    return $self->SUPER::handle_unparsed_line( $line, $handle );
}


sub can_ignore {
    my ( $self, $line, $handle ) = @_;
    if ( $line =~ /\A\s*(?:;|$)/ ) {

        # If there is stuff left in buffer we need to see if it's name value pair.
        if ( exists $self->{__buffer} ) {
            if ( my ( $name, $value ) = $self->parse_value_assignment('') ) {
                $self->set_value( $name, $value );
            }
        }
        return 1;
    }
    return 0;

}

sub finalize {
    my ($self) = @_;
    return if !$self->{__buffer};

    # If there is stuff left in buffer we need to see if it's name value pair.
    if ( my ( $name, $value ) = $self->parse_value_assignment('') ) {
        $self->set_value( $name, $value );
    }

}
  
1;

__END__

=head1 NAME

Config::INI::Reader::Multiline - Parser for .ini files with line continuations

=head1 SYNOPSIS

If F<act.ini> contains:

    [general]
    conferences = ye2003 fpw2004 \
                  apw2005 fpw2005 hpw2005 ipw2005 npw2005 ye2005 \
                  apw2006 fpw2006 ipw2006 npw2006
    cookie_name = act
    searchlimit = 20

And your program does:

    my $config = Config::INI::Reader::Multiline->read_file('act.ini');

Then C<$config> contains:

    {
        general => {
            cookie_name => 'act',
            conferences => 'ye2003 fpw2004 apw2005 fpw2005 hpw2005 ipw2005 npw2005 ye2005 apw2006 fpw2006 ipw2006 npw2006',
            searchlimit => '20'
        }
    }

=head1 DESCRIPTION

Config::INI::Reader::Multiline is a subclass of L<Config::INI::Reader>
that offers support for I<line continuations>, i.e. adding a
C<< \<newline> >> (backslash-newline) at the end of a line to indicate the
newline should be removed from the input stream and ignored.

In this implementation, the backslash can be followed and preceded
by whitespace, which will be ignored too (just as whitespace is trimmed
by L<Config::INI::Reader>).

=head1 METHODS

All methods from L<Config::INI::Reader> are available, and none extra.

=head1 OVERRIDEN METHODS

The following two methods from L<Config::INI::Reader> are overriden
(but still call for the parent version):

=head2 parse_value_assignment

This method skips lines ending with a C<\> and leaves them to
L</handle_unparsed_line> for buffering. When given a "normal" line
to process, it prepends the buffered lines, and lets the ancestor
method deal with the resulting line.

Note that whitespace at the end of continued lines and at the beginning
of continuation lines is trimmed, and that consecutive lines are joined
with a single space character.

=head2 handle_unparsed_line

This method buffers the unparsed lines that contain a C<\> at the end,
and calls its parent class version to deal with the others.

=head1 ACKNOWLEDGEMENTS

Thanks to Vincent Pit for help (on IRC, of course!) in finding a
descriptive but not too long name for this module.

=head1 AUTHOR

Philippe Bruhat (BooK), <book@cpan.org>,
who needed to read F<act.ini> files without L<AppConfig>.

=head1 COPYRIGHT

Copyright 2014-2015 Philippe Bruhat (BooK), all rights reserved.

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
