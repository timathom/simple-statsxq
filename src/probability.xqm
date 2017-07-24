xquery version "3.1";

(:~ 
 :
 : Module name:  Simple StatsXQ Probability
 : Module version:  0.0.1
 : Date:  July 2, 2017
 : License: GPLv3
 : Proprietary XQuery extensions used: none
 : XQuery specification: 3.1
 : Module overview:  This module provides a basic set of statistical functions 
 : for doing data analysis in XQuery. Inspired by the Tom MacWright's (@tmcw) 
 : simple-statistics project for JavaScript.
 : 
 : @author @timathom
 : @version 0.0.1
 : @see https://github.com/simple-statistics/simple-statistics
 :
:)

module namespace prob = "http://bibfram.es/xq/simple-stats/prob/";
declare namespace math = "http://www.w3.org/2005/xpath-functions/math";
declare namespace err = "http://www.w3.org/2005/xqt-errors";
declare namespace errs = "http://bibfram.es/xq/simple-stats/errs/";

import module namespace basic = "http://bibfram.es/xq/simple-stats/basic/" 
  at "../src/basic.xqm";

(:~ 
 : The cumulative distribution function (CDF). Given a value in a sequence of 
 : values, returns the CDF.
 : 
 : @param $nums a sequence of xs:doubles.
 : @return CDF of $nums as a sequence of xs:doubles.
 : @error err:XPTY0004: "Cannot promote empty-sequence() to xs:double+."
 :
 :)
(: declare function prob:cdf(
  $counter as function(xs:double+) as element(counter),
  $nums as xs:double+,
  $value as xs:double
) as xs:double {  
  if (empty($nums)) 
  then () 
  else (
    let $count := $counter($nums),    
    $v := $count/count[@n = $value]
    return (
      sum(
        for $c in $count/*
        where $c/@n lt $v/@n
        return $c        
      ) + $v
    ) div count($count/*)
  )
}; :)

(:~ 
 : The cumulative distribution function (CDF). Given a sequence of values, 
 : returns the CDF for the complete distribution of values.
 : 
 : @param $nums a sequence of xs:doubles.
 : @return CDF as JSON object containing three arrays: "values," "counts,"
 : and "probs."
 : @error err:XPTY0004: "Cannot promote empty-sequence() to xs:double+."
 :
 :)
declare function prob:cdf(
  $counter as function(xs:numeric+) as element(counter),
  $nums as xs:numeric+
) as xs:string {  
  if (empty($nums)) 
  then () (: static error :)
  else (
    let $count := $counter($nums)    
    return (              
      map {
        "values": array { $count/* ! xs:double(@n) },
        "counts": array { $count/* ! xs:integer(.) },
        "probs": array {
          for $c at $p in $count/*
          return 
            ($c + sum($count/*[position() lt $p])) div sum($count/*)
        }                     
      } => serialize(map {"method": "json"})                      
    )                 
  ) 
};



