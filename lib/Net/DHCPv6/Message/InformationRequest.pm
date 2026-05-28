#!/bin/false
# ABSTRACT: Information-Request message (type 11)
# PODNAME: Net::DHCPv6::Message::InformationRequest
package Net::DHCPv6::Message::InformationRequest;

use strictures 2;
use Net::DHCPv6::Constants;
use parent 'Net::DHCPv6::Packet';
use namespace::clean;

sub new {
    my ( $class, %args ) = @_;
    $args{msg_type} = $INFORMATION_REQUEST;
    return $class->SUPER::new( %args );
}

$Net::DHCPv6::Packet::MESSAGE_CLASS{$INFORMATION_REQUEST} = __PACKAGE__;

1;

__END__


=head1 SYNOPSIS

    use Net::DHCPv6;

    my ($msg, $err) = Net::DHCPv6->decode_with_error($bytes);

=head1 DESCRIPTION

DHCPv6 Information-Request message (type 11). Clients send
Information-Request to obtain configuration without acquiring
addresses. See L<Net::DHCPv6::Packet> for available methods.

=for Pod::Coverage new

=head1 SEE ALSO

L<Net::DHCPv6::Packet>, RFC 8415 E<167>18.10
