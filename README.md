#XQuery and XSLT ISBN Function Library#

ISBNs (or International Standard Book Numbers), are used to identify books.  

This function library contains functions to: 
*   Format ISBNs
*   Remove formatting from ISBNs
*   Calculate ISBN-10 and ISBN-13 check digits (for validation)
*   Convert ISBN-10 to ISBN-13
*   Convert ISBN-13 to ISBN-10

##XQuery##

To use the ISBN XQuery functions, first import the isbn.xqy module into the desired main module or library module of your XQuery code base: 

    xquery version "1.0-ml";
    
    import module namespace isbn = "http://github.com/holmesw/isbn" at "/xqy/modules/isbn.xqy";

###Format ISBN###

An **ISBN-10** is formatted in the following way: 
x-xxxxx-xxx-x

This means that 123456789X is formatted as: 1-23456-789-X

An **ISBN-13** is formatted in the following way: 
xxx-x-xxxxx-xxx-x 

This means that 9781234567897 is formatted as: 978-1-23456-789-7

Here is an example of how to format an ISBN (10 or 13 digit): 

    xquery version "1.0-ml";
    
    import module namespace isbn = "http://github.com/holmesw/isbn" at "/xqy/modules/isbn.xqy";
    
    isbn:format-isbn("9781234567897"), 
    (: the output of the above function call is: "978-1-23456-789-7" :)
    
    isbn:format-isbn("978-1-23456-789-7"), 
    (: the output of the above function call is: "978-1-23456-789-7" :)
    
    isbn:format-isbn("123456789X"), 
    (: the output of the above function call is: "1-23456-789-X" :)
    
    isbn:format-isbn("1-23456-789-X")
    (: the output of the above function call is: "1-23456-789-X" :)

###Remove ISBN Formatting###

This function acts to **remove** non alpha-numeric characters from the ISBN, and will thus remove any formartting.   

This is helpful when calculating the check digit.  

Here is an example of how to remove the formatting for an ISBN (10 or 13 digit): 

    xquery version "1.0-ml";
    
    import module namespace isbn = "http://github.com/holmesw/isbn" at "/xqy/modules/isbn.xqy";
    
    isbn:prepare-isbn("9781234567897"), 
    (: the output of the above function call is: "9781234567897" :)
    
    isbn:prepare-isbn("978-1-23456-789-7"), 
    (: the output of the above function call is: "9781234567897" :)
    
    isbn:prepare-isbn("123456789X"), 
    (: the output of the above function call is: "123456789X" :)
    
    isbn:prepare-isbn("1-23456-789-X")
    (: the output of the above function call is: "123456789X" :)

###XQuery Unit Tests###


The XQuery has been tested using xray.  
The test module in included.  


XSLT 2.0
----

To use the XSLT 2.0 functions, import the ISBN XSLT 2.0 function library (with the ISBN XSLT function namespace) into your style sheet.  
Example: 

    <?xml version="1.0" encoding="UTF-8"?>
    <xsl:stylesheet 
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:isbn="http://github.com/holmesw/isbn" 
        exclude-result-prefixes="isbn" 
        version="2.0">
        
        <xsl:include href="/xsl/isbn.xsl"/>
    </xsl:stylesheet>

Here is a more detailed example: 

    <?xml version="1.0" encoding="UTF-8"?>
    <xsl:stylesheet 
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:isbn="http://github.com/holmesw/isbn" 
        exclude-result-prefixes="isbn" 
        version="2.0">
    
        <xsl:include href="/xsl/isbn.xsl"/>
        
        <xsl:template match="isbns">
            <isbns><xsl:apply-templates /></isbns>
        </xsl:template>
        
        <xsl:template match="isbn13format">
            <isbn-13-format><xsl:sequence select="isbn:format-isbn(.)" /></isbn-13-format>
        </xsl:template>
        
        <xsl:template match="isbn13prepare">
            <isbn-13-prepare><xsl:sequence select="isbn:prepare-isbn(.)" /></isbn-13-prepare>
        </xsl:template>
        
        <xsl:template match="isbn13checkdigit">
            <isbn-13-check-digit><xsl:sequence select="isbn:isbn-13-check-digit(.)" /></isbn-13-check-digit>
        </xsl:template>
        
        <xsl:template match="isbn13toisbn10">
            <isbn-13-to-isbn-10><xsl:sequence select="isbn:isbn13-to-isbn10(.)" /></isbn-13-to-isbn-10>
        </xsl:template>
        
        <xsl:template match="isbn10toisbn13">
            <isbn-10-to-isbn-13><xsl:sequence select="isbn:isbn10-to-isbn13(.)" /></isbn-10-to-isbn-13>
        </xsl:template>
        
        <xsl:template match="isbn10format">
            <isbn-10-format><xsl:sequence select="isbn:format-isbn(.)" /></isbn-10-format>
        </xsl:template>
        
        <xsl:template match="isbn10prepare">
            <isbn-10-prepare><xsl:sequence select="isbn:prepare-isbn(.)" /></isbn-10-prepare>
        </xsl:template>
        
        <xsl:template match="isbn10checkdigit">
            <isbn-10-check-digit><xsl:sequence select="isbn:isbn-10-check-digit(.)" /></isbn-10-check-digit>
        </xsl:template>
        
        <xsl:template match="element()" priority="-5">
            <xsl:copy-of select="." />
        </xsl:template>
    </xsl:stylesheet>
