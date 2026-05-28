#!/bin/false
# ABSTRACT: Subscriber ID option (code 38) -- opaque subscriber identification
# PODNAME: Net::DHCPv6::Option::SubscriberId
package Net::DHCPv6::Option::SubscriberId;

use strictures 2;
use Net::DHCPv6::Constants;
use parent 'Net::DHCPv6::Option';
use namespace::clean;

sub new {
    my ( $class, %args ) = @_;
    my $subscriber_id = $args{subscriber_id} // '';
    $args{code} = $OPTION_SUBSCRIBER_ID;
    $args{data} = $subscriber_id;
    my $self = $class->SUPER::new( %args );
    $self->{subscriber_id} = $subscriber_id;
    return bless $self, $class;
}

sub subscriber_id { return shift->{subscriber_id} }

sub from_bytes_inner {
    my ( $class, $code, $data ) = @_;
    return $class->new( subscriber_id => $data );
}

$Net::DHCPv6::OptionList::OPTION_CLASS{$OPTION_SUBSCRIBER_ID} = __PACKAGE__;
1;

__END__


=head1 SYNOPSIS

  use Net::DHCPv6::Option::SubscriberId;
  my $opt = Net::DHCPv6::Option::SubscriberId->new(
      subscriber_id => "\x00\x01\x02",
  );

=head1 DESCRIPTION

Carries an opaque subscriber identifier set by a relay agent.
See RFC 4580.

=head1 METHODS

=head2 new

Constructor.  Optional C<subscriber_id> (opaque bytes, defaults to empty).

=head2 subscriber_id

Returns the opaque subscriber identifier.

=head1 SEE ALSO

L<Net::DHCPv6::Option>, L<Net::DHCPv6::OptionList>
