#!/bin/false
# ABSTRACT: Reconfigure Accept option (code 20) -- zero-length data
# PODNAME: Net::DHCPv6::Option::ReconfAccept
use strictures 2;

package Net::DHCPv6::Option::ReconfAccept;
use Net::DHCPv6::OptionList;
use Net::DHCPv6::Constants;
use parent 'Net::DHCPv6::Option';
use namespace::clean;

sub new {
    my ( $class, %args ) = @_;
    $args{code} = $OPTION_RECONF_ACCEPT;
    return $class->SUPER::new( %args );
}

sub from_bytes_inner {
    my ( $class, $code, $payload ) = @_;
    return $class->new;
}

$Net::DHCPv6::OptionList::OPTION_CLASS{$OPTION_RECONF_ACCEPT} = __PACKAGE__;
1;

__END__


=head1 SYNOPSIS

  use Net::DHCPv6::Option::ReconfAccept;
  my $opt = Net::DHCPv6::Option::ReconfAccept->new;

=head1 DESCRIPTION

Zero-length option used by a server to indicate that the client should
accept reconfiguration.  See RFC 8415 E<167>21.22.

=head1 METHODS

=head2 new

Constructor.  Takes no parameters.

=head1 SEE ALSO

L<Net::DHCPv6::Option>, L<Net::DHCPv6::OptionList>
