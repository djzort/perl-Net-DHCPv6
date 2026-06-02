#!/bin/false
# ABSTRACT: Solicit message (type 1)
# PODNAME: Net::DHCPv6::Message::Solicit
use strictures 2;

package Net::DHCPv6::Message::Solicit;

use Net::DHCPv6::Packet    ();
use Net::DHCPv6::Constants qw(
    $SOLICIT
);
use parent 'Net::DHCPv6::Packet';
use namespace::clean;

sub new {
    my ( $class, %args ) = @_;
    $args{msg_type} = $SOLICIT;
    return $class->SUPER::new( %args );
}

$Net::DHCPv6::Packet::MESSAGE_CLASS{$SOLICIT} = __PACKAGE__;

1;

__END__


=head1 SYNOPSIS

    use Net::DHCPv6;

    my ($msg, $err) = Net::DHCPv6->decode_with_error($bytes);

=head1 DESCRIPTION

DHCPv6 Solicit message (type 1). Clients send Solicit to locate
servers. See L<Net::DHCPv6::Packet> for available methods.

=for Pod::Coverage new

=head1 SEE ALSO

L<Net::DHCPv6::Packet>, L<Net::DHCPv6::Message::Advertise>
