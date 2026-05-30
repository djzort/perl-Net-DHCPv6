#!/bin/false
# ABSTRACT: Thrown on internal logic errors in the library
# PODNAME: Net::DHCPv6::X::Internal
package Net::DHCPv6::X::Internal;

use strictures 2;
use parent 'Net::DHCPv6::X';
use namespace::clean ();

1;

__END__


=head1 SYNOPSIS

    use Net::DHCPv6;

    # Internal exceptions indicate a library bug and are not expected
    # under normal use. They propagate through decode_with_error.
    my ($msg, $err) = Net::DHCPv6->decode_with_error($bytes);
    if ($err && $err->isa('Net::DHCPv6::X::Internal')) {
        warn "internal error: " . $err->message;
    }

=head1 DESCRIPTION

Exception thrown when an internal logic error occurs in the library.
This should never happen under normal use and indicates a bug.

See L<Net::DHCPv6::X>.
