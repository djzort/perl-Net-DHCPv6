#!/bin/false
# ABSTRACT: Interface-ID option (code 18) -- opaque interface identifier
# PODNAME: Net::DHCPv6::Option::InterfaceId
use strictures 2;

package Net::DHCPv6::Option::InterfaceId;
use Net::DHCPv6::OptionList;
use Net::DHCPv6::Constants;
use parent 'Net::DHCPv6::Option';
use namespace::clean;
my $EMPTY = q();

sub new {
    my ( $class, %args ) = @_;
    $args{code} = $OPTION_INTERFACE_ID;
    $args{data} = $args{data} // ( $args{interface_id} // $EMPTY );
    return $class->SUPER::new( %args );
}

sub interface_id { return shift->{data} }

sub from_bytes_inner {
    my ( $class, $code, $payload ) = @_;
    return $class->new( interface_id => $payload );
}

$Net::DHCPv6::OptionList::OPTION_CLASS{$OPTION_INTERFACE_ID} = __PACKAGE__;
1;

__END__


=head1 SYNOPSIS

  use Net::DHCPv6::Option::InterfaceId;
  my $opt = Net::DHCPv6::Option::InterfaceId->new(interface_id => $bytes);

=head1 DESCRIPTION

Opaque identifier used by relay agents to identify the interface on
which the client message was received.  See RFC 8415 E<167>21.18.

=head1 METHODS

=head2 new

Constructor.  Optional C<interface_id> (raw bytes, defaults to empty).

=head2 interface_id

Returns the opaque interface identifier bytes.

=head1 SEE ALSO

L<Net::DHCPv6::Option>, L<Net::DHCPv6::OptionList>
