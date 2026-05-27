#!/usr/bin/false
# ABSTRACT: Remote ID option (code 37) -- enterprise-number + opaque data
# PODNAME: Net::DHCPv6::Option::RemoteId
package Net::DHCPv6::Option::RemoteId;

use strictures 2;
use Carp qw(croak);
use Net::DHCPv6::Constants;
use Net::DHCPv6::X::Truncated;
use parent 'Net::DHCPv6::Option';
use namespace::clean;

sub new {
    my ( $class, %args ) = @_;
    croak 'RemoteId requires enterprise_number' unless defined $args{enterprise_number};
    croak 'RemoteId requires remote_data'       unless defined $args{remote_data};
    $args{code} = $OPTION_REMOTE_ID;
    $args{data} = pack( 'N', $args{enterprise_number} ) . $args{remote_data};
    my $self = $class->SUPER::new( %args );
    $self->{enterprise_number} = $args{enterprise_number};
    $self->{remote_data}       = $args{remote_data};
    return bless $self, $class;
}

sub enterprise_number { return shift->{enterprise_number} }
sub remote_data       { return shift->{remote_data} }

sub from_bytes_inner {
    my ( $class, $code, $data ) = @_;
    Net::DHCPv6::X::Truncated->throw( message => 'Truncated RemoteId option' )
        if CORE::length( $data ) < 4;
    my $en   = unpack( 'N', substr( $data, 0, 4 ) );
    my $rest = substr( $data, 4 );
    return $class->new( enterprise_number => $en, remote_data => $rest );
}

$Net::DHCPv6::OptionList::OPTION_CLASS{$OPTION_REMOTE_ID} = __PACKAGE__;
1;

__END__


=head1 SYNOPSIS

  use Net::DHCPv6::Option::RemoteId;
  my $opt = Net::DHCPv6::Option::RemoteId->new(
      enterprise_number => 9,        # Cisco (IANA PEN)
      remote_data       => "\x00\x01\x02\x03",
  );

=head1 DESCRIPTION

Carries a relay agent's remote identification, consisting of an IANA
Private Enterprise Number (PEN, see
L<https://www.iana.org/assignments/enterprise-numbers>)
and opaque data.  See RFC 4649.

=head1 METHODS

=head2 new

Constructor.  Requires C<enterprise_number> and C<remote_data>.

=head2 enterprise_number

Returns the IANA enterprise number.

=head2 remote_data

Returns the opaque remote identification data.

=head1 SEE ALSO

L<Net::DHCPv6::Option>, L<Net::DHCPv6::OptionList>
