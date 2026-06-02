#!/bin/false
# ABSTRACT: NEW_TZDB_TIMEZONE option (code 42) -- IANA timezone DB name
# PODNAME: Net::DHCPv6::Option::NewTzdbTimezone
use strictures 2;

package Net::DHCPv6::Option::NewTzdbTimezone;

use Net::DHCPv6::OptionList ();
use Carp                    qw( croak );
use Net::DHCPv6::Constants  qw(
    $OPTION_NEW_TZDB_TIMEZONE
);
use parent 'Net::DHCPv6::Option';
use namespace::clean;

sub new {
    my ( $class, %args ) = @_;
    croak 'NewTzdbTimezone requires tz_name' unless defined $args{tz_name};
    $args{code} = $OPTION_NEW_TZDB_TIMEZONE;
    $args{data} = $args{tz_name};
    my $self = $class->SUPER::new( %args );
    $self->{tz_name} = $args{tz_name};
    return bless $self, $class;
}

sub tz_name { return shift->{tz_name} }

sub from_bytes_inner {
    my ( $class, $code, $payload ) = @_;
    return $class->new( tz_name => $payload );
}

$Net::DHCPv6::OptionList::OPTION_CLASS{$OPTION_NEW_TZDB_TIMEZONE} = __PACKAGE__;
1;

__END__


=head1 SYNOPSIS

  use Net::DHCPv6::Option::NewTzdbTimezone;
  my $opt = Net::DHCPv6::Option::NewTzdbTimezone->new(
      tz_name => 'America/New_York',
  );

=head1 DESCRIPTION

Carries a timezone name from the IANA Time Zone Database
(e.g. C<America/New_York>).  See RFC 4833.

=head1 METHODS

=head2 new

Constructor.  Requires C<tz_name>.

=head2 tz_name

Returns the IANA timezone name string.

=head1 SEE ALSO

L<Net::DHCPv6::Option>, L<Net::DHCPv6::OptionList>
