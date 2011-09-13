#!/usr/bin/env php
<?php
include_once __DIR__ . '/../common.php';
use Gaia\Test\Tap;
use Gaia\NewID;
use Gaia\Cache;
Tap::plan(4);

$db = new MySQLi( 
                $host = '127.0.0.1', 
                $user = NULL, 
                $pass = NULL, 
                $dbname = 'test', 
                '3306');
$cache = new Cache\Apc();
$app = 'test';
$new = new NewId\MySQLi( $db, $cache, $app );
$res = $new->testInit();

$id = $new->id();

Tap::ok( ctype_digit( $id ), 'id returned is a string of digits');

$ids = $new->ids(10);

Tap::ok( is_array( $ids ) && count( $ids ) == 10, 'ids returned a list of 10 items when I asked for 10');

$status = TRUE;

foreach( $ids as $id ){
    if( ! ctype_digit( $id ) ) $status = FALSE;
}

Tap::ok( $status, 'all of the ids are digits');

$id1 = $new->id();

$id2 = $new->id();

Tap::cmp_ok( $id1, '<', $id2, 'an id generated a second later is larger than the first one');