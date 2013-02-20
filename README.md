XQuery and XSLT ISBN Function Library
====

This function library contains functions to: 
*   Format ISBNs
*   Remove formatting from ISBNs
*   Calculate ISBN-10 and ISBN-13 check digits (for validation)
*   Convert ISBN-10 to ISBN-13
*   Convert ISBN-13 to ISBN-10

XQuery
----

To use the ISBN XQuery functions, first import the isbn.xqy module into the desired main module or library module of your XQuery code base: 

    xquery version "1.0-ml";
    
    import module namespace isbn = "http://github.com/holmesw/isbn" at "/xqy/modules/isbn.xqy";

XQuery Unit Tests
----

The XQuery has been tested using xray.  
The test module in included.  


XSLT
----

To use the XSLT functions, import the ISBN XSLT function library (with the ISBN XSLT function namespace) into your style sheet.  
Example: 

    <?xml version="1.0" encoding="UTF-8"?>
    <xsl:stylesheet 
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:isbn="http://github.com/holmesw/isbn" 
        exclude-result-prefixes="isbn" 
        version="2.0">
        
        <xsl:include href="/xsl/isbn.xsl"/>
    </xsl:stylesheet>
