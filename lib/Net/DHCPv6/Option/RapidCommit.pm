#!/usr/bin/false
# ABSTRACT: Rapid Commit option (code 14) -- zero-length data
# PODNAME: Net::DHCPv6::Option::RapidCommit
package Net::DHCPv6::Option::RapidCommit;

use strictures 2;
use Net::DHCPv6::Constants;
use Net::DHCPv6::X::BadOption;
use parent 'Net::DHCPv6::Option';
use namespace::clean;

sub new {
    my ( $class, %args ) = @_;
    $args{code} = $OPTION_RAPID_COMMIT;
    my $self = $class->SUPER::new( code => $args{code} );
    bless $self, $class;
}

sub from_bytes_inner {
    my ( $class, $code, $data ) = @_;
    Net::DHCPv6::X::BadOption->throw( message => 'RapidCommit option must be empty' )
        if CORE::length( $data ) > 0;
    return $class->new;
}

$Net::DHCPv6::OptionList::OPTION_CLASS{$OPTION_RAPID_COMMIT} = __PACKAGE__;

1;

__END__


=head1 SYNOPSIS

  my $rc = Net::DHCPv6::Option::RapidCommit->new;

=head1 DESCRIPTION

Implements the Rapid Commit option (OPTION_RAPID_COMMIT, code 14) per
RFC 8415 E<167>21.14. A zero-length option that signals the server should
commit the assignment immediately (solicit-advertise-request-reply
short circuit).

=head1 METHODS

=over

=item B<new>

Constructor. No parameters required.

=back

=head1 SEE ALSO

L<Net::DHCPv6::Option>, L<Net::DHCPv6::OptionList>
