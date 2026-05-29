#!/bin/false
# ABSTRACT: Vendor-specific Information option (code 17) -- enterprise + sub-options
# PODNAME: Net::DHCPv6::Option::VendorOpts
package Net::DHCPv6::Option::VendorOpts;

use strictures 2;
use Net::DHCPv6::OptionList;
use Carp qw( croak );
use Net::DHCPv6::Constants;
use Net::DHCPv6::X::Truncated;
use parent 'Net::DHCPv6::Option';
use Ref::Util        qw( is_plain_arrayref );
use namespace::clean ();
my $EMPTY = q();

sub new {
    my ( $class, %args ) = @_;
    croak 'VendorOpts requires enterprise_number' unless defined $args{enterprise_number};
    $args{code} = $OPTION_VENDOR_OPTS;
    my $sub_data = $args{sub_options} // $EMPTY;
    $sub_data = join( $EMPTY, map { $_->as_bytes } @{$sub_data} ) if is_plain_arrayref( $sub_data );
    $args{data} = pack( 'N', $args{enterprise_number} ) . $sub_data;
    my $self = $class->SUPER::new( %args );
    $self->{enterprise_number} = $args{enterprise_number};
    return bless $self, $class;
}

sub enterprise_number { return shift->{enterprise_number} }

sub from_bytes_inner {
    my ( $class, $code, $payload ) = @_;
    Net::DHCPv6::X::Truncated->throw( message => 'Truncated VendorOpts option' )
        if CORE::length( $payload ) < 4;
    my $en = unpack( 'N', substr( $payload, 0, 4 ) );
    return $class->new( enterprise_number => $en, sub_options => substr( $payload, 4 ) );
}

$Net::DHCPv6::OptionList::OPTION_CLASS{$OPTION_VENDOR_OPTS} = __PACKAGE__;
1;

__END__


=head1 SYNOPSIS

  use Net::DHCPv6::Option::VendorOpts;
  my $opt = Net::DHCPv6::Option::VendorOpts->new(
      enterprise_number => 9,        # Cisco (IANA PEN)
      sub_options       => [ $subopt1, $subopt2 ],
  );

=head1 DESCRIPTION

Carries vendor-specific sub-options scoped by an IANA Private
Enterprise Number (PEN, see L<https://www.iana.org/assignments/enterprise-numbers>).
See RFC 8415 E<167>21.17.

=head1 METHODS

=head2 new

Constructor.  Requires C<enterprise_number>.  Optional C<sub_options>
(an arrayref of L<Net::DHCPv6::Option> objects or raw bytes).

=head2 enterprise_number

Returns the IANA enterprise number.

=head1 SEE ALSO

L<Net::DHCPv6::Option>, L<Net::DHCPv6::OptionList>
