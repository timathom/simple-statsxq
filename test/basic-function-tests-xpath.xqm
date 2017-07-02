xquery version "3.1";

(: module namespace test = "http://basex.org/modules/xqunit-tests"; :)
declare namespace math = "http://www.w3.org/2005/xpath-functions/math";
declare namespace errs = "http://bibfram.es/xq/simple-stats/errs/";

import module namespace stats = "http://bibfram.es/xq/simple-stats/" 
  at "../src/basic-functions-xpath.xqm";
  
$stats:stats("mean")("#2")((1, 2, 3, 4, 5, 3.14), 2)
