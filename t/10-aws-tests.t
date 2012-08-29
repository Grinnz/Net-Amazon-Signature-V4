#!perl -T

use warnings;
use strict;
use Net::Amazon::Signature::V4;
use File::Slurp;
use HTTP::Request;
use Test::More;

my $testsuite_dir = 't/aws4_testsuite';
my @test_names = qw/
	get-vanilla
	get-vanilla-empty-query-key
	get-vanilla-query
	get-vanilla-query-order-key
	get-vanilla-query-order-key-case
	get-vanilla-query-order-value
	get-vanilla-query-unreserved
	get-vanilla-ut8-query
	get-header-key-duplicate
	get-header-value-order
	get-header-value-trim
	get-relative
	get-relative-relative
	get-slash
	get-slash-dot-slash
	get-slashes
	get-slash-pointless-dot 
	get-space 
	get-unreserved
	get-utf8
	post-header-key-case 
	post-header-key-sort
	post-header-value-case 
	post-vanilla 
	post-vanilla-empty-query-value
	post-vanilla-query 
	post-x-www-form-urlencoded 
	post-x-www-form-urlencoded-parameters
/;
# TODO: test get-header-value-multiline (only .req supplied: why?)
# TODO: test post-vanilla-query-space (unsure of test vailidity)
# TODO: test post-vanilla-query-nonunreserved (unsure of test vailidity)

plan tests =>  1+3*@test_names;

my $sig = Net::Amazon::Signature::V4->new(
	'AKIDEXAMPLE',
	'wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY',
	'us-east-1',
	'host',
);

ok( -d $testsuite_dir, 'testsuite directory existence' );

for my $test_name ( @test_names ) {

	my $req = HTTP::Request->parse( scalar read_file( "$testsuite_dir/$test_name.req" ) );

	#diag("$test_name creq");
	my $creq = $sig->_canonical_request( $req );
	string_fits_file( $creq, "$testsuite_dir/$test_name.creq" );

	#diag("$test_name sts");
	my $sts = $sig->_string_to_sign( $req );
	string_fits_file( $sts, "$testsuite_dir/$test_name.sts" );

	#diag("$test_name authz");
	my $authz = $sig->_authorization( $req );
	string_fits_file( $authz, "$testsuite_dir/$test_name.authz" );
}

sub string_fits_file {
	my ( $str, $expected_path ) = @_;
	my $expected_str = read_file( $expected_path );
	$expected_str =~ s/\r\n/\n/g;
	is( $str, $expected_str, $expected_path );
}
