#!/usr/bin/false
# ABSTRACT: Option Request option (code 6)
# PODNAME: Net::DHCPv6::Option::ORO
package Net::DHCPv6::Option::ORO;

use strictures 2;
use Carp qw(croak);
use Net::DHCPv6::Constants;
use Net::DHCPv6::X::BadOption;
use parent 'Net::DHCPv6::Option';
use namespace::clean;

sub new {
    my ( $class, %args ) = @_;
    croak 'ORO requires requested_options (arrayref)' unless $args{requested_options};
    $args{code} = $OPTION_ORO;
    $args{data} = pack( 'n*', @{ $args{requested_options} } );
    my $self = $class->SUPER::new( %args );
    $self->{requested_options} = $args{requested_options};
    bless $self, $class;
}

sub requested_options { shift->{requested_options} }

sub from_bytes_inner {
    my ( $class, $code, $data ) = @_;
    Net::DHCPv6::X::BadOption->throw( message => 'ORO data must have even length' )
        if CORE::length( $data ) % 2 != 0;
    my @codes = unpack( 'n*', $data );
    return $class->new( requested_options => \@codes );
}

sub as_bytes {
    my $self = shift;
    my $data = pack( 'n*', @{ $self->{requested_options} } );
    return pack( 'nn', $self->{code}, CORE::length( $data ) ) . $data;
}

$Net::DHCPv6::OptionList::OPTION_CLASS{$OPTION_ORO} = __PACKAGE__;

1;

__END__


=head1 SYNOPSIS

  use Net::DHCPv6::Constants qw($OPTION_DNS_SERVERS $OPTION_DOMAIN_LIST);

  my $oro = Net::DHCPv6::Option::ORO->new(
      requested_options => [$OPTION_DNS_SERVERS, $OPTION_DOMAIN_LIST],
  );

=head1 DESCRIPTION

Implements the ORO option (OPTION_ORO, code 6) per RFC 8415 E<167>21.7.
Lists option codes the client requests the server to include in
the reply.

=head1 METHODS

=over

=item B<new>(requested_options => \@codes)

Constructor. Requires an arrayref of numeric option codes.

=item B<requested_options>

Returns the arrayref of requested option codes.

=back

=head1 SEE ALSO

L<Net::DHCPv6::Option>, L<Net::DHCPv6::OptionList>
