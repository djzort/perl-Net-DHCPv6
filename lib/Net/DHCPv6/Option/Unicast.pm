#!/usr/bin/false
# ABSTRACT: UNICAST option (code 12) -- server IPv6 address
# PODNAME: Net::DHCPv6::Option::Unicast
package Net::DHCPv6::Option::Unicast;

use strictures 2;
use Carp qw(croak);
use Net::DHCPv6::Constants;
use Net::DHCPv6::X::Truncated;
use parent 'Net::DHCPv6::Option';
use namespace::clean;

sub new {
    my ( $class, %args ) = @_;
    my $addr = $class->_pick_addr( \%args, 'address' );
    croak 'Unicast requires address'
        unless $addr && CORE::length( $addr ) == 16;
    $args{code} = $OPTION_UNICAST;
    $args{data} = $addr;
    my $self = $class->SUPER::new( %args );
    $self->{address} = $addr;
    return bless $self, $class;
}

sub address_raw { return shift->{address} }

sub address {
    my $self = shift;
    return $self->_format_ipv6( $self->{address} );
}

sub from_bytes_inner {
    my ( $class, $code, $data ) = @_;
    Net::DHCPv6::X::Truncated->throw( message => 'Truncated Unicast option' )
        if CORE::length( $data ) < 16;
    return $class->new( address_raw => substr( $data, 0, 16 ) );
}

$Net::DHCPv6::OptionList::OPTION_CLASS{$OPTION_UNICAST} = __PACKAGE__;
1;

__END__


=head1 SYNOPSIS

  use Socket qw(inet_pton AF_INET6);

  # Text form (auto-resolved to wire bytes)
  my $opt = Net::DHCPv6::Option::Unicast->new(address => '2001:db8::1');
  print $opt->address;        # '2001:db8::1'
  print $opt->address_raw;    # 16-byte wire-format bytes

  # Raw bytes from text
  my $opt2 = Net::DHCPv6::Option::Unicast->new(
      address_raw => inet_pton(AF_INET6, '2001:db8::1'),
  );

=head1 DESCRIPTION

Carries the IPv6 address of a server to which the client should send
messages unicast.  See RFC 8415 E<167>21.12.

=head1 METHODS

=head2 new

Constructor.  Requires either C<address> (text) or C<address_raw> (bytes).

=head2 address

Returns the IPv6 address as a text string.

=head2 address_raw

Returns the 16-byte wire-format address.

=head1 SEE ALSO

L<Net::DHCPv6::Option>, L<Net::DHCPv6::OptionList>
