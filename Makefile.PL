use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'      => 'Time::Duration::es',
    'VERSION_FROM' => 'lib/Time/Duration/es.pm', # finds $VERSION
    'PREREQ_PM' => {
	Test::More => 0.32,
        Time::Duration => 1.02,
    },
);
