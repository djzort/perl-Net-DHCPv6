#!/bin/false
# ABSTRACT: Boot File URL option (code 59) -- URL for network boot
# PODNAME: Net::DHCPv6::Option::BootfileUrl
use strictures 2;

package Net::DHCPv6::Option::BootfileUrl;

use Net::DHCPv6::OptionList;
use Carp qw( croak );
use Net::DHCPv6::Constants;
use Net::DHCPv6::X::Truncated;
use parent 'Net::DHCPv6::Option';
use namespace::clean;

sub new {
    my ( $class, %args ) = @_;
    croak 'BootfileUrl requires url' unless defined $args{url};
    $args{code} = $OPTION_BOOTFILE_URL;
    $args{data} = $args{url};
    my $self = $class->SUPER::new( %args );
    $self->{url} = $args{url};
    return bless $self, $class;
}

sub url { return shift->{url} }

sub from_bytes_inner {
    my ( $class, $code, $payload ) = @_;
    Net::DHCPv6::X::Truncated->throw( message => 'Truncated BootfileUrl option' )
        if CORE::length( $payload ) == 0;
    return $class->new( url => $payload );
}

$Net::DHCPv6::OptionList::OPTION_CLASS{$OPTION_BOOTFILE_URL} = __PACKAGE__;
1;

__END__


=head1 SYNOPSIS

  use Net::DHCPv6::Option::BootfileUrl;
  my $opt = Net::DHCPv6::Option::BootfileUrl->new(
      url => 'tftp://192.0.2.1/bootfile',
  );

=head1 DESCRIPTION

Carries a URL pointing to a boot file for network boot (PXE, UEFI,
etc.).  See RFC 5970.

=head1 METHODS

=head2 new

Constructor.  Requires C<url>.

=head2 url

Returns the boot file URL string.

=head1 SEE ALSO

L<Net::DHCPv6::Option>, L<Net::DHCPv6::OptionList>
