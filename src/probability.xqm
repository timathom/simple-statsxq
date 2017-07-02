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

