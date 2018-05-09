#!perl

use warnings;
use strict;
use Net::Amazon::Signature::V4;
use File::Slurper 'read_text';
use HTTP::Request;
use Test::More;
use Sub::Override;

my $testsuite_dir = 't/sign-uri';
my @test_names = qw/sign-uri/; # all tests

plan tests =>  1+5*@test_names;

my $signature = Net::Amazon::Signature::V4->new(
	'AKIAIOSFODNN7EXAMPLE',
	'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY',
	'us-east-1',
	's3',
);

ok( -d $testsuite_dir, 'testsuite directory existence' );

for my $test_name ( @test_names ) {

	my ($creq, $sts, $sign);
	my $_canonical_request = $signature->can( '_canonical_request' );
	my $_string_to_sign    = $signature->can( '_string_to_sign' );
	my $_signature         = $signature->can( '_signature' );

	my $guard = Sub::Override->new;
	$guard->replace( 'Net::Amazon::Signature::V4::_canonical_request' => sub { $creq = $_canonical_request->(@_) } );
	$guard->replace( 'Net::Amazon::Signature::V4::_string_to_sign'    => sub { $sts  = $_string_to_sign->(@_) } );
	$guard->replace( 'Net::Amazon::Signature::V4::_signature'         => sub { $sign = $_signature->(@_) } );

	ok( -f "$testsuite_dir/$test_name.uri", "$test_name.uri existence" );
	my $uri = URI->new( read_text( "$testsuite_dir/$test_name.uri" ) );
	my $suri = $signature->sign_uri( $uri, 86400 );

	string_fits_file( $creq, "$testsuite_dir/$test_name.creq" );
	string_fits_file( $sts,  "$testsuite_dir/$test_name.sts" );
	string_fits_file( $sign, "$testsuite_dir/$test_name.sign" );
	string_fits_file( $suri, "$testsuite_dir/$test_name.suri" );
}

sub string_fits_file {
	my ( $str, $expected_path ) = @_;
	my $expected_str = read_text( $expected_path );
	$expected_str =~ s/\r\n/\n/g;
	$expected_str =~ s/\n$// unless $str =~ m/\n$/;
	is( $str, $expected_str, $expected_path );
	return $str eq $expected_str;
}
