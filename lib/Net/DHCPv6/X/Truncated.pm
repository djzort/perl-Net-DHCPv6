#!/bin/false
# ABSTRACT: Thrown when a buffer is too short for expected data
# PODNAME: Net::DHCPv6::X::Truncated
package Net::DHCPv6::X::Truncated;

use strictures 2;
use parent 'Net::DHCPv6::X';
use namespace::clean;

1;

__END__


=head1 SYNOPSIS

    use Net::DHCPv6;

    my ($msg, $err) = Net::DHCPv6->decode_with_error($short_bytes);
    if ($err && $err->isa('Net::DHCPv6::X::Truncated')) {
        warn "truncated: " . $err->message;
    }

=head1 DESCRIPTION

Exception thrown when a buffer is shorter than the expected header
or data length during wire-format parsing.

See L<Net::DHCPv6::X>.
