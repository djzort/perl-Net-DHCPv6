#!/bin/false
# ABSTRACT: Thrown when option data violates expected format
# PODNAME: Net::DHCPv6::X::BadOption
use strictures 2;

package Net::DHCPv6::X::BadOption;
use parent 'Net::DHCPv6::X';
use namespace::clean;

1;

__END__


=head1 SYNOPSIS

    use Net::DHCPv6;

    my ($msg, $err) = Net::DHCPv6->decode_with_error($bytes);
    if ($err && $err->isa('Net::DHCPv6::X::BadOption')) {
        warn "bad option: " . $err->message;
    }

=head1 DESCRIPTION

Exception thrown when option data cannot be parsed, for example
truncated option content or invalid field values.

See L<Net::DHCPv6::X>.
