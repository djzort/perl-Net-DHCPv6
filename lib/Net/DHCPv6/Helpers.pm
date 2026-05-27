#!/usr/bin/false
# ABSTRACT: Internal helper methods for IPv6 address resolution
# PODNAME: Net::DHCPv6::Helpers
package Net::DHCPv6::Helpers;

use strictures 2;
use Carp   qw(croak);
use Socket qw(inet_pton AF_INET6 inet_ntop);
use namespace::clean;

sub _resolve_ipv6 {
    my ( $class, $arg ) = @_;
    return unless defined $arg;
    return $arg  unless $arg =~ m/:/;
    my $bytes = inet_pton( AF_INET6, $arg );
    croak( "Invalid IPv6 address: $arg" ) unless defined $bytes;
    return $bytes;
}

sub _format_ipv6 {
    my ( $self, $bytes ) = @_;
    return unless defined $bytes;
    return inet_ntop( AF_INET6, $bytes );
}

sub _pick_addr {
    my ( $class, $args, $field ) = @_;
    my $key = "${field}_raw";
    return $args->{$key} if exists $args->{$key};
    return unless defined $args->{$field};
    return $class->_resolve_ipv6( $args->{$field} );
}

sub _pick_addrs {
    my ( $class, $args, $field ) = @_;
    my $key = "${field}_raw";
    return $args->{$key} if exists $args->{$key};
    return unless defined $args->{$field};
    return [ map { $class->_resolve_ipv6( $_ ) } @{ $args->{$field} } ];
}

1;

__END__


=head1 DESCRIPTION

Internal helper methods shared by L<Net::DHCPv6::Option> and
L<Net::DHCPv6::Packet::Relay> for IPv6 address parsing and formatting.

=head1 METHODS

=over

=item B<_resolve_ipv6>($arg)

If C<$arg> contains C<:>, treat as text and convert to 16-byte wire format
via C<inet_pton>. Otherwise pass through as raw bytes.

=item B<_format_ipv6>($bytes)

Convert 16-byte wire-format address to text via C<inet_ntop>.

=item B<_pick_addr>( \%args, $field )

Helper for constructor argument processing. If C<$field_raw> exists in
C<\%args>, return it directly. Else if C<$field> exists, pass it through
L</_resolve_ipv6>. Otherwise return C<undef>.

=item B<_pick_addrs>( \%args, $field )

Like L</_pick_addr> but for arrayrefs of addresses.

=back

=head1 SEE ALSO

L<Net::DHCPv6::Option>, L<Net::DHCPv6::Packet::Relay>
