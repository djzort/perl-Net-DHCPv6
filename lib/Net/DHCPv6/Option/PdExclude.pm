#!/usr/bin/false
# ABSTRACT: PD Exclude option (code 67) — prefix to exclude from IA_PD
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
    croak 'PdExclude requires address'       unless $args{address};
    $args{code} = $OPTION_PD_EXCLUDE;
    $args{data} = pack( 'C', $args{prefix_length} ) . $args{address};
    my $self = $class->SUPER::new( %args );
    $self->{prefix_length} = $args{prefix_length};
    $self->{address}       = $args{address};
    bless $self, $class;
}

sub prefix_length { shift->{prefix_length} }
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
    return $class->new( prefix_length => $plen, address => $addr );
}

sub as_bytes {
    my $self = shift;
    my $data = pack( 'C', $self->{prefix_length} ) . $self->{address};
    return pack( 'nn', $self->{code}, CORE::length( $data ) ) . $data;
}

$Net::DHCPv6::OptionList::OPTION_CLASS{$OPTION_PD_EXCLUDE} = __PACKAGE__;
1;

__END__

=encoding utf-8

=head1 SYNOPSIS

  use Socket qw(inet_pton AF_INET6);
  use Net::DHCPv6::Option::PdExclude;
  my $opt = Net::DHCPv6::Option::PdExclude->new(
      prefix_length => 48,
      address       => inet_pton( AF_INET6, '2001:db8::' ),
  );

=head1 DESCRIPTION

Carries a prefix that the requesting router must exclude from the
delegated prefix set.  See RFC 6603.

=head1 METHODS

=head2 new

Constructor.  Requires C<prefix_length> and C<address> (the prefix
address bytes, with length derived from prefix_length).

=head2 prefix_length

Returns the prefix length in bits.

=head2 address

Returns the prefix address bytes.

=head1 SEE ALSO

L<Net::DHCPv6::Option>, L<Net::DHCPv6::OptionList>
