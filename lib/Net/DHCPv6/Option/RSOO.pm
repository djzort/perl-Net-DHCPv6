#!/bin/false
# ABSTRACT: Relay-Supplied Options option (code 66) -- opaque
# PODNAME: Net::DHCPv6::Option::RSOO
package Net::DHCPv6::Option::RSOO;

use strictures 2;
use Net::DHCPv6::OptionList;
use Net::DHCPv6::Constants;
use parent 'Net::DHCPv6::Option';
use namespace::clean ();
my $EMPTY = q();

sub new {
    my ( $class, %args ) = @_;
    $args{code} = $OPTION_RSOO;
    $args{data} = $args{data} // ( $args{option_data} // $EMPTY );
    return $class->SUPER::new( %args );
}

sub option_data { return shift->{data} }

sub from_bytes_inner {
    my ( $class, $code, $payload ) = @_;
    return $class->new( option_data => $payload );
}

$Net::DHCPv6::OptionList::OPTION_CLASS{$OPTION_RSOO} = __PACKAGE__;
1;

__END__


=head1 SYNOPSIS

  use Net::DHCPv6::Option::RSOO;
  my $opt = Net::DHCPv6::Option::RSOO->new(option_data => $bytes);

=head1 DESCRIPTION

Opaque container for options supplied by a relay agent and
returned in server responses.  See RFC 8415 E<167>21.24.

=head1 METHODS

=head2 new

Constructor.  Optional C<option_data> (raw bytes, defaults to empty).

=head2 option_data

Returns the relay-supplied option data bytes.

=head1 SEE ALSO

L<Net::DHCPv6::Option>, L<Net::DHCPv6::OptionList>
