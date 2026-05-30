#!/bin/false
# ABSTRACT: Exception base class for Net::DHCPv6
# PODNAME: Net::DHCPv6::X
package Net::DHCPv6::X;

use strictures 2;
use Carp qw( croak );
use namespace::clean ();

sub throw {
    my ( $class, %args ) = @_;
    my $self = bless {%args}, $class;
    croak $self;
}

sub message { return shift->{message} }

1;

__END__


=head1 SYNOPSIS

  Net::DHCPv6::X::Truncated->throw(message => 'Buffer too short');

=head1 DESCRIPTION

Base class for all Net::DHCPv6 exceptions. Exceptions are objects, not
strings. Use C<isa> checks to distinguish error types:

  if ($@ && $@->isa('Net::DHCPv6::X::Truncated')) { ... }

=head1 SUBCLASSES

=over

=item L<Net::DHCPv6::X::Truncated>

Thrown when a buffer is too short for expected header or data.

=item L<Net::DHCPv6::X::BadDUID>

Thrown when DUID data is invalid.

=item L<Net::DHCPv6::X::BadOption>

Thrown when option data violates the expected format.

=item L<Net::DHCPv6::X::BadMessage>

Thrown when a message header is invalid or corrupt.

=item L<Net::DHCPv6::X::Internal>

Thrown on internal logic errors in the library.

=back

=head1 METHODS

=over

=item B<throw>(message => $str, ...)

Creates a new exception object and croaks with it. Extra key-value pairs
are stored on the object.

=item B<message>

Returns the human-readable error message string.

=back
