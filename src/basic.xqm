xquery version "3.1";

(:~ 
 :
 : Module name:  Simple StatsXQ Basic
 : Module version:  0.0.1
 : Date:  June 23, 2017
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

module namespace basic = "http://bibfram.es/xq/simple-stats/basic/";
declare namespace math = "http://www.w3.org/2005/xpath-functions/math";
declare namespace err = "http://www.w3.org/2005/xqt-errors";
declare namespace errs = "http://bibfram.es/xq/simple-stats/errs/";


(:~ 
 : 
 : Constructs a counter object from a sequence of values, with a corresponding
 : frequency count for each distinct value:
 : 
 : @param $nums as sequence of xs:doubles
 : @return counter as element(counter)
 :
 :)
declare function basic:counter(
  $nums as xs:numeric+
) as element(counter) {
  <counter>{
    for $n in distinct-values($nums)
    order by $n
    return
      <count n="{$n}">{ count(index-of($nums, $n)) }</count>
  }</counter>
};

(:~ 
 : Calculates the factorial of a non-negative integer.
 : 
 : @param $num a non-negative xs:double.
 : @return factorial of $num as xs:double.
 : @error BF0001: "Requires a non-negative value."
 : @error BF0002: "Requires an integer value as input."
 :
 :)
declare function basic:fact(
  $num as xs:numeric
) as xs:double {  
  if (empty($num) or $num lt 0) 
  then error(xs:QName("errs:BF0001"), "Requires a non-negative value.")
  else if (floor($num) ne $num)
    then error(xs:QName("errs:BF0002"), "Requires an integer value as input.")
    else if ($num le 1) 
      then 1 
      else $num * basic:fact($num - 1)
};

(:~ 
 : Formats an xs:double to a given number of decimal places.
 :
 : @param $num is the xs:double value to be formatted.
 : @param $places is the number of decimal places to output.
 : @return xs:double formatted to the specified number of decimal places.
 :
 :)
declare function basic:format-decimal(
  $num as xs:numeric,
  $places as xs:integer
) as xs:double {
  let $zeros as xs:string := 
    concat(".",
      string-join(
        for $z in 1 to $places return "0"  
      )
    )
  return  
    format-number($num, $zeros) cast as xs:double
};

(:~ 
 : Calculates the arithmetic mean of a sequence of numbers.
 : 
 : @param $nums a sequence of xs:doubles.
 : @return mean of $nums as xs:double.
 :
 :)
declare function basic:mean(
    $nums as xs:numeric+
) as xs:double {     
  sum($nums) div count($nums)      
};

(:~ 
 : Calculates the arithmetic mean of a sequence of numbers, with an option to
 : format the number of decimal places in the result.
 : 
 : @param $nums a sequence of xs:doubles.
 : @param $places an xs:integer indicating the number of decimal places to 
 : output.
 : @return mean of $nums as xs:double, formatted to the number of decimal
 : places specified in $places.
 :
 :)
declare function basic:mean(
    $nums as xs:numeric+,
    $places as xs:integer?
) as xs:double {     
  basic:format-decimal(
    basic:mean($nums), $places  
  )
};

(:~
 : Calculates the product of a sequece of xs:numerics.
 :
 : @param $nums a sequence of xs:numerics.
 : @return product of $nums as xs:numeric.
 :)
declare function basic:product(
  $nums as xs:numeric+
) as xs:numeric {
  let $n := $nums
  return
    fold-left($n, 1, function($a, $b) { $a * $b })
};

(:~
 : Calculates the variance of a population.
 :
 : @param $nums a sequence of xs:doubles.
 : @return variance of $nums as xs:double.
 :
 :)
declare function basic:pvar(
  $nums as xs:numeric+
) as xs:double {
  sum(
    for $n in $nums return math:pow(($n - basic:mean($nums)), 2)    
  ) div count($nums)
};

(:~ 
 : Calculates the variance of a population, with an option to
 : format the number of decimal places in the result.
 :
 : @param $nums a sequence of xs:doubles.
 : @param $places an xs:integer indicating the number of decimal places to 
 : output.
 : @return variance of $nums as xs:double, formatted to the number of decimal
 : places specified in $places.
 :
 :)
declare function basic:pvar(
  $nums as xs:numeric+,
  $places as xs:integer
) as xs:double {
  basic:format-decimal(
    sum(
      for $n in $nums return math:pow(($n - basic:mean($nums)), 2)    
    ) div count($nums), $places
  )
};

(:~
 : Calculates the quantile of a sorted sequence of xs:numerics.
 :
 : @param $nums a sequence of xs:numerics.
 : @param $q the desired quantile(s), as a sequence of xs:doubles between 0 and 1.
 : @error BF0003 "Requires at least one numeric value."
 : @error BF0004 "Requires a value between 0 and 1"
 : @return $quantile as xs:numeric.
 :)
declare function basic:quantile(
  $nums as xs:numeric+,
  $qs as xs:numeric+
) as xs:numeric+ {
  (: verify $nums is not empty :)
  if (fn:empty($nums) or fn:count($nums) lt 0)
  then fn:error(xs:QName("errs:BF0003"), "Requires at least one numeric value.")
  (: verify that each quantile (qi) in the quantiles sequence (qs) is not empty or gt/lt 1/0 :)
  else if (fn:not(every $qi in $qs satisfies (fn:not(fn:empty($qi)) and ($qi gt 0 or $qi lt 1))))
    then fn:error(xs:QName("errs:BF0004"), "Requires a value between 0 and 1.")
    (: process our nums :)
    else let $sorted-nums := for $i in $nums
                             order by fn:number($i)
                             return $i
    for $q in $qs
    let $count-nums := fn:count($nums)
    let $mid := fn:ceiling($count-nums div 2)
    let $rounded := fn:round(($count-nums + 1) * $q)
    return (
      if ($count-nums mod 2 eq 0)
      then (fn:avg(fn:subsequence($sorted-nums, $mid, 2)))
      else ($sorted-nums[$mid])
    )
};