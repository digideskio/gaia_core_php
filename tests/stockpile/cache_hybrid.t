#!/usr/bin/env php
<?php
namespace Gaia\Stockpile;
use Gaia\Test\Tap;
require __DIR__ . '/lib/setup.php';

// how many tests are we gonna run?
Tap::plan(96);

// utility function for instantiating the object 
function stockpile( $app, $user_id ){
    return new Cacher( new Hybrid( $app, $user_id ), memcache() );
}

// wrap in try/catch so we can fail and print out debug.
try {
    include __DIR__ . '/lib/common_tests.php';
     include __DIR__ . '/lib/cache_tests.php';
    include __DIR__ . '/lib/trade_tests.php';
    include __DIR__ . '/lib/hybrid_tests.php';


} catch( Exception $e ){
    Tap::fail( 'unexpected exception thrown' );
    print $e;
}
