#!/bin/false
# ABSTRACT: Thrown when DUID data is invalid
# PODNAME: Net::DHCPv6::X::BadDUID
use strictures 2;

package Net::DHCPv6::X::BadDUID;
use parent 'Net::DHCPv6::X';
use namespace::clean;

1;

__END__


=head1 SYNOPSIS

    use Net::DHCPv6;

    my ($msg, $err) = Net::DHCPv6->decode_with_error($bytes);
    if ($err && $err->isa('Net::DHCPv6::X::BadDUID')) {
        warn "bad DUID: " . $err->message;
    }

=head1 DESCRIPTION

Exception thrown when DUID data violates the expected format,
such as an unknown DUID type or invalid payload length.

See L<Net::DHCPv6::X>.
