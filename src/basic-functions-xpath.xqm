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
 : for doing data analysis in XQuery. Inspired by the Tom MacWright's (@tmcw) 
 : simple-statistics project for JavaScript.
 : 
 : @author @timathom
 : @version 0.0.1
 : @see https://github.com/simple-statistics/simple-statistics
 :
:)

module namespace stats = "http://bibfram.es/xq/simple-stats/";
declare namespace math = "http://www.w3.org/2005/xpath-functions/math";
declare namespace errs = "http://bibfram.es/xq/simple-stats/errs/";

declare variable $stats:stats :=
  let
    (:~ 
     : Formats an xs:double to a given number of decimal places.
     :
     : @param $num is the xs:double value to be formatted.
     : @param $places is the number of decimal places to output.
     : @return xs:double formatted to the specified number of decimal places.
     :
     :)
    $format-decimal := 
      function(
        $nums as xs:double,
        $places as xs:integer
      ) as xs:double {
        let $zeros as xs:string :=
          concat(".",
            string-join(
              for $z in 1 to $places return "0"
            )
          )
        return
          format-number($nums, $zeros) cast as xs:double
      },
    (:~ 
     : Calculates the arithmetic mean of a sequence of numbers.
     : 
     : @param $nums a sequence of xs:doubles.
     : @return mean of $nums as xs:double.
     :
     :)
    $mean1 := 
      function(
        $nums as xs:double+
      ) as xs:double {
        sum($nums) div count($nums)
      }, 
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
    $mean2 := 
      function(
        $nums as xs:double+,
        $places as xs:integer?
      ) as xs:double {
        $format-decimal(
          $mean1($nums), $places
        )
      },
    
    $pvar1 := function() {()},
    
    $pvar2 := function() {()},
    
    $fact := function() {()}
    


  return
    map {
      "mean": map {"#1": $mean1, "#2": $mean2},
      "format-decimal": $format-decimal      
    }
;