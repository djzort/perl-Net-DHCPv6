#!/bin/false
# ABSTRACT: Fallback option for unknown codes -- stores raw code+data
# PODNAME: Net::DHCPv6::Option::Generic
use strictures 2;

package Net::DHCPv6::Option::Generic;
use parent 'Net::DHCPv6::Option';
use namespace::clean;

sub from_bytes_inner {
    my ( $class, $code, $payload ) = @_;
    return $class->new( code => $code, data => $payload );
}

1;

__END__


=head1 SYNOPSIS

    use Net::DHCPv6;

    my ($msg, $err) = Net::DHCPv6->decode_with_error($bytes);
    my $opt = $msg->options->get_option(999);  # unknown code
    my $payload = $opt->data if $opt;

    # Or construct directly
    use Net::DHCPv6::Option::Generic;
    my $gen = Net::DHCPv6::Option::Generic->new(code => 123, data => "\x00\x01");

=head1 DESCRIPTION

Pass-through container for option codes with no dedicated subclass.
Stores the raw code and data intact, enabling lossless re-encoding of
unknown options. When a parse failure occurs in a known option class
and the error is a Net::DHCPv6::X exception, the option falls back
to Generic to preserve data.

=head1 SEE ALSO

L<Net::DHCPv6::Option>
