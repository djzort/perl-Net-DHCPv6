#!/bin/false
# ABSTRACT: Decline message (type 9)
# PODNAME: Net::DHCPv6::Message::Decline
package Net::DHCPv6::Message::Decline;

use strictures 2;
use Net::DHCPv6::Packet;
use Net::DHCPv6::Constants;
use parent 'Net::DHCPv6::Packet';
use namespace::clean;

sub new {
    my ( $class, %args ) = @_;
    $args{msg_type} = $DECLINE;
    return $class->SUPER::new( %args );
}

$Net::DHCPv6::Packet::MESSAGE_CLASS{$DECLINE} = __PACKAGE__;

1;

__END__


=head1 SYNOPSIS

    use Net::DHCPv6;

    my ($msg, $err) = Net::DHCPv6->decode_with_error($bytes);

=head1 DESCRIPTION

DHCPv6 Decline message (type 9). Clients send Decline to indicate
a leased address is already in use. See L<Net::DHCPv6::Packet>
for available methods.

=for Pod::Coverage new

=head1 SEE ALSO

L<Net::DHCPv6::Packet>, RFC 8415 E<167>18.8
