use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

my %WriteMakefile_args = (
    NAME                => 'Net::Amazon::Signature::V4',
    AUTHOR              => q{Tim Nordenfur <tim@gurka.se>},
    VERSION_FROM        => 'lib/Net/Amazon/Signature/V4.pm',
    ABSTRACT_FROM       => 'lib/Net/Amazon/Signature/V4.pm',
    MIN_PERL_VERSION    => '5.8.1',
    LICENSE             => 'perl',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'Digest::SHA' => 0,
        'DateTime::Format::Strptime' => 0,
        'HTTP::Request' => 0,
        'URI::Escape' => 0,
        'File::Slurp' => 0, # used by tests
    },
    META_MERGE => {
        'meta-spec' => { version => 2 },
        dynamic_config => 0,
        resources => {
            repository => {
                type => 'git',
                url  => 'https://github.com/Grinnz/Net-Amazon-Signature-V4.git',
                web  => 'https://github.com/Grinnz/Net-Amazon-Signature-V4',
            },
        },
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Net-Amazon-Signature-V4-*' },
);

delete $WriteMakefile_args{LICENSE}
  unless eval { ExtUtils::MakeMaker->VERSION('6.31') };
delete $WriteMakefile_args{META_MERGE}
  unless eval { ExtUtils::MakeMaker->VERSION('6.46') };
delete $WriteMakefile_args{MIN_PERL_VERSION}
  unless eval { ExtUtils::MakeMaker->VERSION('6.48') };

WriteMakefile(%WriteMakefile_args);
