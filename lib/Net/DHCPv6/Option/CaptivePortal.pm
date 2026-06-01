#!/bin/false
# ABSTRACT: DHCP Captive-Portal option (code 103) -- captive portal API URI
# PODNAME: Net::DHCPv6::Option::CaptivePortal
use strictures 2;

package Net::DHCPv6::Option::CaptivePortal;
use Net::DHCPv6::OptionList;
use Carp qw( croak );
use Net::DHCPv6::Constants;
use Net::DHCPv6::X::Truncated;
use parent 'Net::DHCPv6::Option';
use namespace::clean;

sub new {
    my ( $class, %args ) = @_;
    croak 'CaptivePortal requires uri' unless defined $args{uri};
    $args{code} = $OPTION_CAPTIVE_PORTAL;
    $args{data} = $args{uri};
    my $self = $class->SUPER::new( %args );
    $self->{uri} = $args{uri};
    return bless $self, $class;
}

sub uri { return shift->{uri} }

sub from_bytes_inner {
    my ( $class, $code, $payload ) = @_;
    Net::DHCPv6::X::Truncated->throw( message => 'Truncated CaptivePortal option' )
        if CORE::length( $payload ) == 0;
    return $class->new( uri => $payload );
}

$Net::DHCPv6::OptionList::OPTION_CLASS{$OPTION_CAPTIVE_PORTAL} = __PACKAGE__;
1;

__END__


=head1 SYNOPSIS

  use Net::DHCPv6::Option::CaptivePortal;
  my $opt = Net::DHCPv6::Option::CaptivePortal->new(
      uri => 'https://example.com/portal',
  );

=head1 DESCRIPTION

Carries a URI for a captive portal API endpoint, allowing clients to
detect and interact with captive portals.  See RFC 8910.

=head1 METHODS

=head2 new

Constructor.  Requires C<uri>.

=head2 uri

Returns the captive portal API URI.

=head1 SEE ALSO

L<Net::DHCPv6::Option>, L<Net::DHCPv6::OptionList>
