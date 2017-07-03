xquery version "3.1";

module namespace test = "http://basex.org/modules/xqunit-tests";
declare namespace math = "http://www.w3.org/2005/xpath-functions/math";
declare namespace err = "http://www.w3.org/2005/xqt-errors";
declare namespace errs = "http://bibfram.es/xq/simple-stats/errs/";

import module namespace basic = "http://bibfram.es/xq/simple-stats/basic/" 
  at "../src/basic.xqm"; 
import module namespace prob = "http://bibfram.es/xq/simple-stats/prob/" 
  at "../src/probability.xqm";

(:~ 
 :  prob:cdf with an empty sequence.
 :)
declare 
  %unit:test("expected", "err:XPTY0004") 
function test:cdf-empty() {
    prob:cdf((), (), ())
};

(:~ 
 :
 :prob:cdf#2 with a sequence of xs:doubles 
 :
 :)
declare
  %unit:test
function test:cdf-total() {
  let $nums :=
     (-0.1412, 0.6152, 0.6852, 2.2946, 3.2791, 3.4699, 
      3.6961, 4.2375, 4.4977, 5.3756)
  return
    prob:cdf(basic:counter#1, $nums)
};

(:~ 
 :  prob:cdf#3 with a sequence of xs:doubles
 :)
declare
  %unit:test
function test:cdf-value() {
  unit:assert(
    let $nums :=
      (-0.1412, 0.6152, 0.6852, 2.2946, 3.2791, 3.4699, 
      3.6961, 4.2375, 4.4977, 5.3756),    
    $cdf := prob:cdf(basic:counter#1, $nums)
    return (
      if (count($cdf("values")) eq count($cdf("counts"))
            and $cdf?("counts")?(array:size($cdf?("counts"))) eq 1)
      then true()
      else false()
    )            
  )  
};

