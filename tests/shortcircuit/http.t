#!/usr/bin/env php
<?php
include_once __DIR__ . '/../common.php';
use Gaia\Test\Tap;

if( ! @fsockopen('127.0.0.1', 11299) ){
    Tap::plan('skip_all', 'unable to connect to remote host for test');
}

if( ! function_exists('curl_init') ){
    Tap::plan('skip_all', 'php curl library not installed');
}

Tap::plan(5);

$ch = curl_init("http://127.0.0.1:11299/shortcircuit.php/test/");
curl_setopt( $ch, CURLOPT_RETURNTRANSFER, 1 );
$res = trim(curl_exec($ch));
$info = curl_getinfo($ch);
curl_close($ch);

Tap::is( $info['http_code'], 200, 'page request returned a 200 ok response');
Tap::is($res, 'hello 123', 'got back the content I expected');


$ch = curl_init("http://127.0.0.1:11299/shortcircuit.php/idtest/123/");
curl_setopt( $ch, CURLOPT_RETURNTRANSFER, 1 );
$res = trim( curl_exec($ch) );
$info = curl_getinfo($ch);
curl_close($ch);
Tap::is($res, '<p>id: 123</p>', 'the id in the url was mapped into the request');

$ch = curl_init("http://127.0.0.1:11299/shortcircuit.php/linktest/?");
curl_setopt( $ch, CURLOPT_RETURNTRANSFER, 1 );
$res = trim( curl_exec($ch) );
$info = curl_getinfo($ch);
Tap::is($res, '<a href="/shortcircuit.php/lt">linktest</a>', 'Link parameters mapped into a url with correct base url');

$ch = curl_init("http://127.0.0.1:11299/shortcircuit.php/lt/3/2/1/");
curl_setopt( $ch, CURLOPT_RETURNTRANSFER, 1 );
$res = trim( curl_exec($ch) );
$info = curl_getinfo($ch);

Tap::is($res, '<a href="/shortcircuit.php/lt/3/2/1">linktest</a>', 'params in the url are mapped into a link with correct base url');

