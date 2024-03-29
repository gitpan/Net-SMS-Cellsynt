#!/usr/bin/perl
use strict;
use Test::More tests => 8;
use Net::SMS::Cellsynt;

my $sms = Net::SMS::Cellsynt->new(
	username=>'username',
	password=>'password',
	origtype=>'alpha',
	orig=>'test',
	test=>1,
);

# correct input
my $hash = $sms->send_sms(to=>'0046700123456', text=>'hej');
is(
	$hash->{status},
	'ok-test'
);

is(
	$hash->{uri},
	"https://se-1.cellsynt.net/sms.php?" . join('&',
		'username=username',
		'password=password',
		'destination=0046700123456',
		'text=hej',
		'originatortype=alpha',
		'originator=test'
	)
);

# incorrect telephone number format
$hash = $sms->send_sms(to=>'0700123456', text=>'hej'),
is(
	$hash->{status},
	'error-internal',
	"Handling of unexpected phone number formats (status)"
);

is(
	$hash->{message},
	'Phone number not in expected format',
	"Handling of unexpected phone number formats (message)"
);

$sms = Net::SMS::Cellsynt->new(
	username=>'zibri',
	password=>'password',
	origtype=>'alpha',
	orig=>'test',
	test=>1,
);

# using example script (username zibri)
$hash = $sms->send_sms(to=>'0046700123456', text=>'hej'),
is(
	$hash->{status},
	'error-internal',
	"Don't run the example script as is (status)"
);

is(
	$hash->{message},
	"Don't run the example script as is",
	"Don't run the example script as is (message)"
);

$sms = Net::SMS::Cellsynt->new(
	username=>'username',
	password=>'password',
	origtype=>'alpha',
	orig=>'test',
	uri=>'http://example.org/'
);

$hash = $sms->send_sms(to=>'0046700123456', text=>'hej'),
is(
	$hash->{status},
	'error-internal',
	"Handling of SMS gateways that don't follow protocol (status)"
);

is(
	$hash->{message},
	"SMS gateway does not follow protocol (empty body)",
	"Handling of SMS gateways that don't follow protocol (message)"
);

