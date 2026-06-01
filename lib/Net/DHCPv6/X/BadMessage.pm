#!/bin/false
# ABSTRACT: Thrown when a message header is invalid
# PODNAME: Net::DHCPv6::X::BadMessage
use strictures 2;

package Net::DHCPv6::X::BadMessage;

use parent 'Net::DHCPv6::X';
use namespace::clean;

1;

__END__


=head1 SYNOPSIS

    use Net::DHCPv6;

    my ($msg, $err) = Net::DHCPv6->decode_with_error($bytes);
    if ($err && $err->isa('Net::DHCPv6::X::BadMessage')) {
        warn "bad message: " . $err->message;
    }

=head1 DESCRIPTION

Exception thrown when a DHCPv6 message header is invalid or corrupt,
such as an unrecognised message type or truncated header.

See L<Net::DHCPv6::X>.
