#!/bin/false
# ABSTRACT: SOL_MAX_RT option (code 10) -- maximum solicit retransmission duration (32-bit)
# PODNAME: Net::DHCPv6::Option::SolMaxRt
use strictures 2;

package Net::DHCPv6::Option::SolMaxRt;

use Net::DHCPv6::OptionList;
use Carp qw( croak );
use Net::DHCPv6::Constants;
use Net::DHCPv6::X::BadOption;
use parent 'Net::DHCPv6::Option';
use namespace::clean;

sub new {
    my ( $class, %args ) = @_;
    croak 'SolMaxRt requires value' unless defined $args{value};
    $args{code} = $OPTION_SOL_MAX_RT;
    $args{data} = pack( 'N', $args{value} );
    my $self = $class->SUPER::new( %args );
    $self->{value} = $args{value};
    return bless $self, $class;
}

sub value { return shift->{value} }

sub from_bytes_inner {
    my ( $class, $code, $payload ) = @_;
    Net::DHCPv6::X::BadOption->throw( message => 'SolMaxRt must be exactly 4 bytes' )
        if CORE::length( $payload ) != 4;    ## no critic (ValuesAndExpressions::ProhibitMagicNumbers)
    my $value = unpack( 'N', $payload );
    return $class->new( value => $value );
}

$Net::DHCPv6::OptionList::OPTION_CLASS{$OPTION_SOL_MAX_RT} = __PACKAGE__;
1;

__END__


=head1 SYNOPSIS

  use Net::DHCPv6::Option::SolMaxRt;
   my $opt = Net::DHCPv6::Option::SolMaxRt->new(value => 3_600);

=head1 DESCRIPTION

Carries the maximum retransmission duration (in seconds) for Solicit
messages.  See RFC 8415 E<167>21.10.

=head1 METHODS

=head2 new

Constructor.  Requires C<value>, a 32-bit unsigned integer.

=head2 value

Returns the maximum retransmission duration in seconds.

=head1 SEE ALSO

L<Net::DHCPv6::Option>, L<Net::DHCPv6::OptionList>
