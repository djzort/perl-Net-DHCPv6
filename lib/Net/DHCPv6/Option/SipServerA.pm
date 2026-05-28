#!/bin/false
# ABSTRACT: SIP Server A option (code 22) -- list of IPv6 addresses
# PODNAME: Net::DHCPv6::Option::SipServerA
package Net::DHCPv6::Option::SipServerA;

use strictures 2;
use Net::DHCPv6::OptionList;
use Net::DHCPv6::Constants;
use Net::DHCPv6::X::Truncated;
use parent 'Net::DHCPv6::Option';
use Ref::Util qw( is_plain_arrayref );
use namespace::clean ();

sub new {
    my ( $class, %args ) = @_;
    my $addrs = $class->_pick_addrs( \%args, 'servers' );
    if ( !defined $addrs && $args{addresses} ) {
        my $list = is_plain_arrayref( $args{addresses} ) ? $args{addresses} : [ $args{addresses} ];
        $addrs = [ map { $class->_resolve_ipv6( $_ ) } @{$list} ];
    }
    $addrs //= [];
    $args{code} = $OPTION_SIP_SERVER_A;
    $args{data} = join( '', @{$addrs} );
    my $self = $class->SUPER::new( %args );
    $self->{servers} = $addrs;
    return bless $self, $class;
}

sub servers_raw { return shift->{servers} }

sub servers {
    my $self = shift;
    return [ map { $self->_format_ipv6( $_ ) } @{ $self->{servers} } ];
}

sub from_bytes_inner {
    my ( $class, $code, $data ) = @_;
    Net::DHCPv6::X::Truncated->throw( message => 'Truncated SipServerA option' )
        if CORE::length( $data ) % 16 != 0;
    my @addrs;
    for ( my $i = 0 ; $i < CORE::length( $data ) ; $i += 16 ) {
        push @addrs, substr( $data, $i, 16 );
    }
    return $class->new( servers_raw => \@addrs );
}

$Net::DHCPv6::OptionList::OPTION_CLASS{$OPTION_SIP_SERVER_A} = __PACKAGE__;
1;

__END__


=head1 SYNOPSIS

  # Text form (auto-resolved to wire bytes)
  my $opt = Net::DHCPv6::Option::SipServerA->new(
      servers => [ '2001:db8::1', '2001:db8::2' ],
  );
  print $opt->servers->[0];           # '2001:db8::1'
  print $opt->servers_raw->[0];       # 16-byte wire-format bytes

  # Raw bytes
  use Socket qw(inet_pton AF_INET6);
  my $opt2 = Net::DHCPv6::Option::SipServerA->new(
      servers_raw => [ inet_pton( AF_INET6, '2001:db8::1' ) ],
  );

=head1 DESCRIPTION

Carries a list of IPv6 addresses of SIP servers available to
the client.  See RFC 3319.

=head1 METHODS

=head2 new

Constructor.  Optional C<servers> (arrayref of IPv6 text addresses) or
C<servers_raw> (arrayref of 16-byte IPv6 addresses).

=head2 servers

Returns an arrayref of IPv6 text addresses.

=head2 servers_raw

Returns an arrayref of 16-byte wire-format addresses.

=head1 SEE ALSO

L<Net::DHCPv6::Option>, L<Net::DHCPv6::OptionList>
