#!/bin/false
# ABSTRACT: IA Prefix option (code 26) -- prefix delegation sub-option
# PODNAME: Net::DHCPv6::Option::IAPrefix
package Net::DHCPv6::Option::IAPrefix;

use strictures 2;
use Carp qw(croak);
use Net::DHCPv6::Constants;
use Net::DHCPv6::OptionList;
use Net::DHCPv6::X::Truncated;
use parent 'Net::DHCPv6::Option';
use namespace::clean;

sub new {
    my ( $class, %args ) = @_;
    my $addr = $class->_pick_addr( \%args, 'address' );
    croak 'IAPrefix requires address' unless $addr && CORE::length( $addr ) == 16;
    $args{code}               = $OPTION_IAPREFIX;
    $args{preferred_lifetime} = $args{preferred_lifetime} // 0;
    $args{valid_lifetime}     = $args{valid_lifetime}     // 0;
    $args{prefix_length}      = $args{prefix_length}      // 0;
    $args{options}            = $args{options}            // Net::DHCPv6::OptionList->new;
    my $data =
          pack( 'N N', $args{preferred_lifetime}, $args{valid_lifetime} )
        . pack( 'C', $args{prefix_length} )
        . $addr
        . $args{options}->as_bytes;
    $args{data} = $data;
    my $self = $class->SUPER::new( %args );
    $self->{address}            = $addr;
    $self->{preferred_lifetime} = $args{preferred_lifetime};
    $self->{valid_lifetime}     = $args{valid_lifetime};
    $self->{prefix_length}      = $args{prefix_length};
    $self->{options}            = $args{options};
    return bless $self, $class;
}

sub address_raw { return shift->{address} }

sub address {
    my $self = shift;
    return $self->_format_ipv6( $self->{address} );
}
sub preferred_lifetime { return shift->{preferred_lifetime} }
sub valid_lifetime     { return shift->{valid_lifetime} }
sub prefix_length      { return shift->{prefix_length} }
sub options            { return shift->{options} }

sub add_option {
    my ( $self, $option ) = @_;
    return $self->{options}->add_option( $option );
}

sub get_option {
    my ( $self, $code ) = @_;
    return $self->{options}->get_option( $code );
}

sub from_bytes_inner {
    my ( $class, $code, $data ) = @_;
    Net::DHCPv6::X::Truncated->throw( message => 'Truncated IAPrefix option' )
        if CORE::length( $data ) < 25;
    my ( $pl, $vl ) = unpack( 'N N', substr( $data, 0, 8 ) );
    my $plen     = unpack( 'C', substr( $data, 8, 1 ) );
    my $addr     = substr( $data, 9, 16 );
    my $opt_data = substr( $data, 25 );
    my $opts     = Net::DHCPv6::OptionList->from_bytes( $opt_data );
    return $class->new(
        address_raw        => $addr,
        preferred_lifetime => $pl,
        valid_lifetime     => $vl,
        prefix_length      => $plen,
        options            => $opts,
    );
}

sub as_bytes {
    my $self = shift;
    my $data =
          pack( 'N N', $self->{preferred_lifetime}, $self->{valid_lifetime} )
        . pack( 'C', $self->{prefix_length} )
        . $self->{address}
        . $self->{options}->as_bytes;
    return pack( 'nn', $self->{code}, CORE::length( $data ) ) . $data;
}

$Net::DHCPv6::OptionList::OPTION_CLASS{$OPTION_IAPREFIX} = __PACKAGE__;

1;

__END__


=head1 SYNOPSIS

  # Text form (auto-resolved to wire bytes)
  my $iaprefix = Net::DHCPv6::Option::IAPrefix->new(
      address            => '2001:db8::',
      preferred_lifetime => 7_200,
      valid_lifetime     => 86_400,
      prefix_length      => 64,
  );
  print $iaprefix->address;             # '2001:db8::'
  print $iaprefix->address_raw;         # 16-byte wire-format bytes

  # Raw bytes
  use Socket qw(inet_pton AF_INET6);
  my $iaprefix2 = Net::DHCPv6::Option::IAPrefix->new(
      address_raw        => inet_pton( AF_INET6, '2001:db8::' ),
      preferred_lifetime => 7_200,
      valid_lifetime     => 86_400,
      prefix_length      => 64,
  );

=head1 DESCRIPTION

Implements the IAPREFIX option (OPTION_IAPREFIX, code 26) per
RFC 8415 E<167>21.23. A sub-option of IA_PD containing an IPv6 prefix,
preferred lifetime, valid lifetime, prefix length, and sub-options.

=head1 METHODS

=over

=item B<new>(address => $text | address_raw => $bytes16, preferred_lifetime => $num, valid_lifetime => $num, prefix_length => $num, options => $optionlist)

Constructor. Requires either C<address> (IPv6 text) or C<address_raw>
(16 raw bytes). C<prefix_length> is the number of significant bits in
the prefix.

=item B<address>

Returns the IPv6 prefix address as a text string.

=item B<address_raw>

Returns the 16-byte wire-format address.

=item B<preferred_lifetime>

Returns preferred lifetime in seconds.

=item B<valid_lifetime>

Returns valid lifetime in seconds.

=item B<prefix_length>

Returns the prefix length in bits.

=item B<options>

Returns the internal L<Net::DHCPv6::OptionList> of sub-options.

=item B<add_option>($option)

Add a sub-option.

=item B<get_option>($code)

Retrieve the first sub-option with the given code.

=back

=head1 SEE ALSO

L<Net::DHCPv6::Option>, L<Net::DHCPv6::Option::IAPD>
