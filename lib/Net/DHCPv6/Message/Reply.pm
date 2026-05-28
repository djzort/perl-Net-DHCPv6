#!/bin/false
# ABSTRACT: Reply message (type 7)
# PODNAME: Net::DHCPv6::Message::Reply
package Net::DHCPv6::Message::Reply;

use strictures 2;
use Net::DHCPv6::Packet;
use Net::DHCPv6::Constants;
use parent 'Net::DHCPv6::Packet';
use namespace::clean ();

sub new {
    my ( $class, %args ) = @_;
    $args{msg_type} = $REPLY;
    return $class->SUPER::new( %args );
}

$Net::DHCPv6::Packet::MESSAGE_CLASS{$REPLY} = __PACKAGE__;

1;

__END__


=head1 SYNOPSIS

    use Net::DHCPv6;

    my ($msg, $err) = Net::DHCPv6->decode_with_error($bytes);

=head1 DESCRIPTION

DHCPv6 Reply message (type 7). Servers send Reply in response to
Solicit, Request, Renew, Rebind, Release, and Decline messages.
See L<Net::DHCPv6::Packet> for available methods.

=for Pod::Coverage new

=head1 SEE ALSO

L<Net::DHCPv6::Packet>, L<Net::DHCPv6::Message::Request>,
L<Net::DHCPv6::Message::Solicit>
