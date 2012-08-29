use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Net::Amazon::Signature::V4',
    AUTHOR              => q{Tim Nordenfur <tim@gurka.se>},
    VERSION_FROM        => 'lib/Net/Amazon/Signature/V4.pm',
    ABSTRACT_FROM       => 'lib/Net/Amazon/Signature/V4.pm',
	MIN_PERL_VERSION    => 5.10.0,
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
		'Digest::SHA' => 0,
		'DateTime::Format::Strptime' => 0,
		'File::Slurp' => 0, # used by tests
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Net-Amazon-Signature-V4-*' },
);
