#!perl

use strict;
use warnings;
use Net::Amazon::Signature::V4;
use Test::More tests => 8;

my %args = (
	access_key_id => 'abc',
	secret        => 'def',
	endpoint      => 'ghi',
	service       => 'jkl',
);

my $ordered = Net::Amazon::Signature::V4->new(@args{qw(access_key_id secret endpoint service)});
is $ordered->{$_}, $args{$_}, "right $_" for sort keys %args;

my $hashref = Net::Amazon::Signature::V4->new(\%args);
is $hashref->{$_}, $args{$_}, "right $_" for sort keys %args;
