#!/usr/bin/false
# ABSTRACT: NEW_POSIX_TIMEZONE option (code 41) -- POSIX timezone string
# PODNAME: Net::DHCPv6::Option::NewPosixTimezone
package Net::DHCPv6::Option::NewPosixTimezone;

use strictures 2;
use Carp qw(croak);
use Net::DHCPv6::Constants;
use parent 'Net::DHCPv6::Option';
use namespace::clean;

sub new {
    my ( $class, %args ) = @_;
    croak 'NewPosixTimezone requires tz_string' unless defined $args{tz_string};
    $args{code} = $OPTION_NEW_POSIX_TIMEZONE;
    $args{data} = $args{tz_string};
    my $self = $class->SUPER::new( %args );
    $self->{tz_string} = $args{tz_string};
    bless $self, $class;
}

sub tz_string { shift->{tz_string} }

sub from_bytes_inner {
    my ( $class, $code, $data ) = @_;
    return $class->new( tz_string => $data );
}

$Net::DHCPv6::OptionList::OPTION_CLASS{$OPTION_NEW_POSIX_TIMEZONE} = __PACKAGE__;
1;

__END__


=head1 SYNOPSIS

  use Net::DHCPv6::Option::NewPosixTimezone;
  my $opt = Net::DHCPv6::Option::NewPosixTimezone->new(
      tz_string => 'EST5EDT',
  );

=head1 DESCRIPTION

Carries a POSIX timezone string (e.g. C<EST5EDT>).  See RFC 4833.

=head1 METHODS

=head2 new

Constructor.  Requires C<tz_string>.

=head2 tz_string

Returns the POSIX timezone string.

=head1 SEE ALSO

L<Net::DHCPv6::Option>, L<Net::DHCPv6::OptionList>
