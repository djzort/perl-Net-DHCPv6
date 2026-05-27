#!/usr/bin/false
# ABSTRACT: PD Exclude option (code 67) -- prefix to exclude from IA_PD
# PODNAME: Net::DHCPv6::Option::PdExclude
package Net::DHCPv6::Option::PdExclude;

use strictures 2;
use Carp qw(croak);
use Net::DHCPv6::Constants;
use Net::DHCPv6::X::Truncated;
use Net::DHCPv6::X::BadOption;
use parent 'Net::DHCPv6::Option';
use namespace::clean;

sub new {
    my ( $class, %args ) = @_;
    croak 'PdExclude requires prefix_length' unless defined $args{prefix_length};
    my $addr = $class->_pick_addr( \%args, 'address' );
    croak 'PdExclude requires address' unless $addr;
    my $addr_len = ( $args{prefix_length} + 7 ) >> 3;
    $addr       = substr( $addr, 0, $addr_len );
    $args{code} = $OPTION_PD_EXCLUDE;
    $args{data} = pack( 'C', $args{prefix_length} ) . $addr;
    my $self = $class->SUPER::new( %args );
    $self->{prefix_length} = $args{prefix_length};
    $self->{address}       = $addr;
    bless $self, $class;
}

sub prefix_length { shift->{prefix_length} }
sub address_raw   { shift->{address} }
sub address       { shift->{address} }

sub from_bytes_inner {
    my ( $class, $code, $data ) = @_;
    Net::DHCPv6::X::Truncated->throw( message => 'Truncated PdExclude option' )
        if CORE::length( $data ) < 2;
    my $plen     = unpack( 'C', substr( $data, 0, 1 ) );
    my $addr_len = ( $plen + 7 ) >> 3;
    Net::DHCPv6::X::Truncated->throw( message => 'Truncated PdExclude address' )
        if 1 + $addr_len > CORE::length( $data );
    my $addr = substr( $data, 1, $addr_len );
    return $class->new( prefix_length => $plen, address_raw => $addr );
}

sub as_bytes {
    my $self = shift;
    my $data = pack( 'C', $self->{prefix_length} ) . $self->{address};
    return pack( 'nn', $self->{code}, CORE::length( $data ) ) . $data;
}

$Net::DHCPv6::OptionList::OPTION_CLASS{$OPTION_PD_EXCLUDE} = __PACKAGE__;
1;

__END__


=head1 SYNOPSIS

  # Text form (auto-resolved, truncated to prefix length)
  my $opt = Net::DHCPv6::Option::PdExclude->new(
      prefix_length => 48,
      address       => '2001:db8::',
  );

  # Raw bytes (already truncated to prefix length)
  use Socket qw(inet_pton AF_INET6);
  my $opt2 = Net::DHCPv6::Option::PdExclude->new(
      prefix_length => 48,
      address_raw   => inet_pton( AF_INET6, '2001:db8::' ),
  );

=head1 DESCRIPTION

Carries a prefix that the requesting router must exclude from the
delegated prefix set.  See RFC 6603.

=head1 METHODS

=head2 new

Constructor.  Requires C<prefix_length> and either C<address> (IPv6 text)
or C<address_raw> (prefix bytes).  Text addresses are truncated to
ceil(prefix_length/8) bytes.

=head2 address

Returns the prefix address bytes (variable-length, not full 16 bytes).

=head2 address_raw

Returns the prefix address bytes (same as C<address>).

=head1 SEE ALSO

L<Net::DHCPv6::Option>, L<Net::DHCPv6::OptionList>
