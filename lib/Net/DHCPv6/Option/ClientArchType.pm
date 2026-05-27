#!/usr/bin/false
# ABSTRACT: Client System Architecture Type option (code 61) -- 16-bit architecture type
# PODNAME: Net::DHCPv6::Option::ClientArchType
package Net::DHCPv6::Option::ClientArchType;

use strictures 2;
use Carp qw(croak);
use Net::DHCPv6::Constants;
use Net::DHCPv6::X::BadOption;
use parent 'Net::DHCPv6::Option';
use namespace::clean;

sub new {
    my ( $class, %args ) = @_;
    croak 'ClientArchType requires type' unless defined $args{type};
    $args{code} = $OPTION_CLIENT_ARCH_TYPE;
    $args{data} = pack( 'n', $args{type} );
    my $self = $class->SUPER::new( %args );
    $self->{type} = $args{type};
    bless $self, $class;
}

sub type { shift->{type} }

sub from_bytes_inner {
    my ( $class, $code, $data ) = @_;
    Net::DHCPv6::X::BadOption->throw( message => 'ClientArchType must be exactly 2 bytes' )
        if CORE::length( $data ) != 2;
    my $type = unpack( 'n', $data );
    return $class->new( type => $type );
}

sub as_bytes {
    my $self = shift;
    my $data = pack( 'n', $self->{type} );
    return pack( 'nn', $self->{code}, CORE::length( $data ) ) . $data;
}

$Net::DHCPv6::OptionList::OPTION_CLASS{$OPTION_CLIENT_ARCH_TYPE} = __PACKAGE__;
1;

__END__


=head1 SYNOPSIS

  use Net::DHCPv6::Option::ClientArchType;
  use Net::DHCPv6::Constants qw($CLIENT_ARCH_X86_UEFI arch_name);

  my $opt = Net::DHCPv6::Option::ClientArchType->new(
      type => $CLIENT_ARCH_X86_UEFI
  );
  print arch_name( $opt->type );  # X86_UEFI

=head1 DESCRIPTION

Carries a 16-bit client system architecture type per RFC 5970.
Common types include:

=over

=item C<$CLIENT_ARCH_X86_BIOS> (0) -- x86 BIOS

=item C<$CLIENT_ARCH_X86_UEFI> (6) -- x86 UEFI

=item C<$CLIENT_ARCH_ARM_64_UEFI> (11) -- ARM 64-bit UEFI

=back

All 42 IANA-registered architecture types are available as constants in
L<Net::DHCPv6::Constants/"Client Architecture Types (RFC 5970)">.

=head1 METHODS

=head2 new

Constructor.  Requires C<type>, a 16-bit unsigned integer matching one of
the C<$CLIENT_ARCH_*> constants.

=head2 type

Returns the architecture type code.

=head1 SEE ALSO

L<Net::DHCPv6::Constants/"Client Architecture Types (RFC 5970)">,
L<Net::DHCPv6::Option>, L<Net::DHCPv6::OptionList>
