#!/bin/false
# ABSTRACT: Client Identifier option (code 1)
# PODNAME: Net::DHCPv6::Option::ClientId
package Net::DHCPv6::Option::ClientId;

use strictures 2;
use Net::DHCPv6::OptionList;
use Net::DHCPv6::DUID;
use Carp qw( croak );
use Net::DHCPv6::Constants;
use parent 'Net::DHCPv6::Option';
use namespace::clean ();

sub new {
    my ( $class, %args ) = @_;
    croak 'ClientId requires a duid' unless $args{duid};
    $args{code} = $OPTION_CLIENTID;
    $args{data} = $args{duid}->as_bytes;
    my $self = $class->SUPER::new( %args );
    $self->{duid} = $args{duid};
    return bless $self, $class;
}

sub duid { return shift->{duid} }

sub from_bytes_inner {
    my ( $class, $code, $payload ) = @_;
    my $duid = Net::DHCPv6::DUID->from_bytes( $payload );
    return $class->new( duid => $duid );
}

sub as_bytes {
    my $self    = shift;
    my $payload = $self->{duid}->as_bytes;
    return pack( 'nn', $self->{code}, CORE::length( $payload ) ) . $payload;
}

$Net::DHCPv6::OptionList::OPTION_CLASS{$OPTION_CLIENTID} = __PACKAGE__;

1;

__END__


=head1 SYNOPSIS

  my $cid = Net::DHCPv6::Option::ClientId->new(duid => $duid);
  print $cid->duid->duid_type;

=head1 DESCRIPTION

Implements the Client Identifier option (OPTION_CLIENTID, code 1)
per RFC 8415 E<167>21.2. The option data contains a single DUID.

=head1 METHODS

=over

=item B<new>(duid => $duid)

Constructor. Requires a L<Net::DHCPv6::DUID> object.

=item B<duid>

Returns the contained L<Net::DHCPv6::DUID> object.

=back

=head1 SEE ALSO

L<Net::DHCPv6::Option>, L<Net::DHCPv6::Option::ServerId>, L<Net::DHCPv6::DUID>
