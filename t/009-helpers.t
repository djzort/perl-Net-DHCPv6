#!/usr/bin/env perl
use strictures 2;
use Test2::Tools::Exception qw( dies lives );
use Test2::V1 -ipP, qw(is ok done_testing);            ## no critic (Subroutines::ProhibitCallsToUndeclaredSubs)

use lib 't/lib';
use lib 'lib';

use Socket qw( AF_INET6 inet_pton inet_ntop );

use Net::DHCPv6::Helpers;

my $class  = 'Net::DHCPv6::Helpers';
my $loop   = inet_pton( AF_INET6, '::1' );
my $ll     = inet_pton( AF_INET6, 'fe80::1' );
my $global = inet_pton( AF_INET6, '2001:db8::1' );

# _resolve_ipv6

ok( !defined $class->_resolve_ipv6( undef ), '_resolve_ipv6: undef returns undef' );

ok( dies { $class->_resolve_ipv6( q() ) }, '_resolve_ipv6: empty string dies' );

is( $class->_resolve_ipv6( $loop ), $loop, '_resolve_ipv6: 16-byte wire format pass-through' );

my $wire_with_colon_byte = pack( 'C*', ( 0x3A, ( 0x00 ) x 15 ) );
is( $class->_resolve_ipv6( $wire_with_colon_byte ),
    $wire_with_colon_byte, '_resolve_ipv6: 16-byte wire with 0x3A byte pass-through' );

is( $class->_resolve_ipv6( $ll ),     $ll,     '_resolve_ipv6: link-local wire pass-through' );
is( $class->_resolve_ipv6( $global ), $global, '_resolve_ipv6: global wire pass-through' );

is( $class->_resolve_ipv6( '::1' ),         $loop,   '_resolve_ipv6: text ::1' );
is( $class->_resolve_ipv6( 'fe80::1' ),     $ll,     '_resolve_ipv6: text fe80::1' );
is( $class->_resolve_ipv6( '2001:db8::1' ), $global, '_resolve_ipv6: text 2001:db8::1' );

ok( dies { $class->_resolve_ipv6( 'short' ) }, '_resolve_ipv6: non-16-byte without colon dies' );

ok( dies { $class->_resolve_ipv6( 'not:an:ip' ) }, '_resolve_ipv6: invalid text with colons dies' );

# _format_ipv6

ok( !defined $class->_format_ipv6( undef ), '_format_ipv6: undef returns undef' );
is( $class->_format_ipv6( $loop ),   '::1',         '_format_ipv6: loopback' );
is( $class->_format_ipv6( $ll ),     'fe80::1',     '_format_ipv6: link-local' );
is( $class->_format_ipv6( $global ), '2001:db8::1', '_format_ipv6: global' );

done_testing();
