#!/bin/false
# ABSTRACT: Relay Message option (code 9) -- encapsulated relay message
# PODNAME: Net::DHCPv6::Option::RelayMsg
package Net::DHCPv6::Option::RelayMsg;

use strictures 2;
use Net::DHCPv6::OptionList;
use Net::DHCPv6::Constants;
use parent 'Net::DHCPv6::Option';
use namespace::clean;
my $EMPTY = q();

sub new {
    my ( $class, %args ) = @_;
    $args{code} = $OPTION_RELAY_MSG;
    $args{data} = $args{data} // ( $args{message} // $EMPTY );
    my $self = $class->SUPER::new( %args );
    $self->{message} = $args{data};
    return bless $self, $class;
}

sub message { return shift->{message} }

sub from_bytes_inner {
    my ( $class, $code, $payload ) = @_;
    return $class->new( message => $payload );
}

$Net::DHCPv6::OptionList::OPTION_CLASS{$OPTION_RELAY_MSG} = __PACKAGE__;
1;

__END__


=head1 SYNOPSIS

  use Net::DHCPv6::Option::RelayMsg;
  my $opt = Net::DHCPv6::Option::RelayMsg->new(message => $bytes);

=head1 DESCRIPTION

Carries an encapsulated DHCPv6 message between relay agents and
servers.  See RFC 8415 E<167>21.9.

=head1 METHODS

=head2 new

Constructor.  Optional C<message> (raw bytes, defaults to empty).

=head2 message

Returns the encapsulated message bytes.

=head1 SEE ALSO

L<Net::DHCPv6::Option>, L<Net::DHCPv6::OptionList>
