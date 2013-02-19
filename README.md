XQuery and XSLT ISBN Function Library
====

This function library contains functions to: 
*   Format ISBNs
*   Remove formatting from ISBNs
*   Validate ISBN-10 and ISBN-13 check digits
*   Convert ISBN-10 to ISBN-13
*   Convert ISBN-13 to ISBN-10

XQuery
----

Import the isbn.xqy module into the desired main module or library module of your XQuery code base: 

    xquery version "1.0-ml";
    
    import module namespace isbn = "http://www.example.org/xquery/functions/isbn" at "/xqy/modules/isbn.xqy";

XQuery Unit Tests
----

The XQuery has been tested using xray.  
The test module in included.  


XSLT
----

This is some information about the XSLT
