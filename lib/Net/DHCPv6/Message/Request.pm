#!/bin/false
# ABSTRACT: Request message (type 3)
# PODNAME: Net::DHCPv6::Message::Request
package Net::DHCPv6::Message::Request;

use strictures 2;
use Net::DHCPv6::Packet;
use Net::DHCPv6::Constants;
use parent 'Net::DHCPv6::Packet';
use namespace::clean;

sub new {
    my ( $class, %args ) = @_;
    $args{msg_type} = $REQUEST;
    return $class->SUPER::new( %args );
}

$Net::DHCPv6::Packet::MESSAGE_CLASS{$REQUEST} = __PACKAGE__;

1;

__END__


=head1 SYNOPSIS

    use Net::DHCPv6;

    my ($msg, $err) = Net::DHCPv6->decode_with_error($bytes);

=head1 DESCRIPTION

DHCPv6 Request message (type 3). Clients send Request after
selecting a server. See L<Net::DHCPv6::Packet> for available
methods.

=for Pod::Coverage new

=head1 SEE ALSO

L<Net::DHCPv6::Packet>, L<Net::DHCPv6::Message::Reply>
