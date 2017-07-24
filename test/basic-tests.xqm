xquery version "3.1";

module namespace test = "http://basex.org/modules/xqunit-tests";
declare namespace math = "http://www.w3.org/2005/xpath-functions/math";
declare namespace errs = "http://bibfram.es/xq/simple-stats/errs/";

import module namespace basic = "http://bibfram.es/xq/simple-stats/basic/" 
  at "../src/basic.xqm";

(:~ 
 : basic:counter() with a sequence of numbers
 :)
declare
  %unit:test
function test:counter() {
  let $nums := (-0.1412, 0.6152, 0.6852, 0.6852, 0.6852, 2.2946, 2.2946, 3.2791,
    3.4699, 3.6961, 4.2375, 4.4977, 5.3756),
  $counter := basic:counter($nums)
  return
    unit:assert(
      $counter/count/@n[xs:double(.) = 2.2946][xs:integer(..) eq 2]
    )
};

(:~  
 :  basic:fact() with negative integer as input. Fails with errs:BF0001
 :)
declare 
  %unit:test("expected", "errs:BF0001") 
function test:factorial-negative() {
    basic:fact(-1)
};

(:~  
 :  basic:fact() with noninteger input. Fails with errs:BF0002
 :)
declare 
  %unit:test("expected", "errs:BF0002") 
function test:factorial-nonint() {
    basic:fact(3.14159)
};
 
(:~  
 :  basic:fact() with 0 as input
 :)
declare 
  %unit:test 
function test:factorial-0() {
  unit:assert-equals(
    basic:fact(0), 1
  )
};

(:~  
 :  basic:fact() with 20 as input
 :)
declare 
  %unit:test 
function test:factorial-20() {
  unit:assert-equals(
    basic:fact(20), 2432902008176640000
  )
};

(:~  
 :  basic:fact() with 100 as input
 :)
declare 
  %unit:test 
function test:factorial-100() {
  unit:assert-equals(
    basic:fact(100), 9.33262154439441E157
  )
};

(:~  
 :  basic:format for decimal formatting
 :)
declare 
  %unit:test 
function test:format-decimal() {
  unit:assert-equals(
    basic:format-decimal(3.14159, 4), 3.1416
  )
};

(:~  
:  basic:mean#1 with a sequence of numbers
:)
declare 
  %unit:test 
function test:mean-1() {
  unit:assert-equals(
    basic:mean((1, 2, 3, 4, 5.5)), 3.1
  )
};

(:~  
:  basic:mean#2 with a sequence of numbers and decimal
:  formatting
:)
declare 
  %unit:test 
function test:mean-2() {
  unit:assert-equals(
    basic:mean((1, 2, 3.14159, 4, 5.5), 2), 3.13
  )
};

(:~ 
 : basic:pvar#1 (population variance) with a sequence of numbers
 :)
declare 
  %unit:test 
function test:pvar-1() {
  unit:assert-equals(
    basic:pvar((1, 2, 3, 4, 5.5)), 2.44
  )
};

(:~ 
 : basic:pvar#2 (population variance) with a sequence of numbers and decimal 
 : formatting
 :)
declare 
  %unit:test 
function test:pvar-2() {
  unit:assert-equals(
    basic:pvar((1, 2, 3, 4, 5.5), 1), 2.4
  )
};