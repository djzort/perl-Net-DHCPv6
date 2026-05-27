#!/usr/bin/false
# ABSTRACT: Relay-Reply message (type 13)
# PODNAME: Net::DHCPv6::Message::RelayReply
package Net::DHCPv6::Message::RelayReply;

use strictures 2;
use Net::DHCPv6::Constants;
use parent 'Net::DHCPv6::Packet::Relay';
use namespace::clean;

sub new {
    my ( $class, %args ) = @_;
    $args{msg_type} = $RELAY_REPLY;
    $class->SUPER::new( %args );
}

$Net::DHCPv6::Packet::MESSAGE_CLASS{$RELAY_REPLY} = __PACKAGE__;

1;

__END__


=head1 SYNOPSIS

    use Net::DHCPv6;

    my ($msg, $err) = Net::DHCPv6->decode_with_error($bytes);
    my $inner = $msg->message;  # decoded inner message

=head1 DESCRIPTION

DHCPv6 Relay-Reply message (type 13). A server sends Relay-Reply
to deliver a response to a relay agent. Wire format: hop_count(1)
+ link_address(16) + peer_address(16) + options. See
L<Net::DHCPv6::Packet::Relay> for available methods.

=for Pod::Coverage new

=head1 SEE ALSO

L<Net::DHCPv6::Packet::Relay>, L<Net::DHCPv6::Message::RelayForw>,
RFC 8415 E<167>14, E<167>20
