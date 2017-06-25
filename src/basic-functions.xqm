xquery version "3.1";

(:~ 
 :
 : Module name:  Simple StatsXQ
 : Module version:  0.0.1
 : Date:  June 23, 2017
 : License: GPLv3
 : Proprietary XQuery extensions used: none
 : XQuery specification: 3.1
 : Module overview:  This module provides a basic set of statistical functions 
 : for doing data analysis in XQuery.
 : 
 : @author timathom
 : @version 0.0.1
:)

module namespace stats = "http://bibfram.es/xq/simple-stats/";
declare namespace math = "http://www.w3.org/2005/xpath-functions/math";

(:~ 
 : Calculates the arithmetic mean of a sequence of numbers.
 : 
 : @param $nums a sequence of xs:doubles.
 : @return mean of $nums as xs:double.
 :
 :)
declare function stats:mean(
    $nums as xs:double+
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
declare function stats:mean(
    $nums as xs:double+,
    $places as xs:integer?
) as xs:double {     
  stats:format-decimal(
    stats:mean($nums), $places  
  )
};

(:~ 
 : Calculates the variance of a population.
 :
 : @param $nums a sequence of xs:doubles.
 : @return variance of $nums as xs:double.
 :
 :)
declare function stats:pvar(
  $nums as xs:double+
) as xs:double {
  sum(
    for $n in $nums return math:pow(($n - stats:mean($nums)), 2)    
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
declare function stats:pvar(
  $nums as xs:double+,
  $places as xs:integer
) as xs:double {
  stats:format-decimal(
    sum(
      for $n in $nums return math:pow(($n - stats:mean($nums)), 2)    
    ) div count($nums), $places
  )
};

(:~ 
 : Calculates the factorial of a non-negative integer.
 : 
 : @param $num a non-negative xs:double.
 : @return factorial of $num as xs:double.
 :
 :)
declare function stats:fact(
  $num as xs:double
) as xs:double {  
  if (empty($num) or $num le 1) then 1 else $num * stats:fact($num - 1)
};

(:~ 
 : Formats an xs:double to a given number of decimal places.
 :
 : @param $num is the xs:double value to be formatted.
 : @param $places is the number of decimal places to output.
 : @return xs:double formatted to the specified number of decimal places.
 :
 :)
declare function stats:format-decimal(
  $num as xs:double,
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
