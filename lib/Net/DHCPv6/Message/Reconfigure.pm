#!/usr/bin/false
# ABSTRACT: Reconfigure message (type 10)
# PODNAME: Net::DHCPv6::Message::Reconfigure
package Net::DHCPv6::Message::Reconfigure;

use strictures 2;
use Net::DHCPv6::Constants;
use parent 'Net::DHCPv6::Packet';
use namespace::clean;

sub new {
    my ( $class, %args ) = @_;
    $args{msg_type} = $RECONFIGURE;
    $class->SUPER::new( %args );
}

$Net::DHCPv6::Packet::MESSAGE_CLASS{$RECONFIGURE} = __PACKAGE__;

1;

__END__


=head1 SYNOPSIS

    use Net::DHCPv6;

    my ($msg, $err) = Net::DHCPv6->decode_with_error($bytes);

=head1 DESCRIPTION

DHCPv6 Reconfigure message (type 10). Servers send Reconfigure to
trigger a client to initiate Solicit or Information-Request. See
L<Net::DHCPv6::Packet> for available methods.

=for Pod::Coverage new

=head1 SEE ALSO

L<Net::DHCPv6::Packet>, RFC 8415 E<167>18.12
