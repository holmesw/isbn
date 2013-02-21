#XQuery 1.0-ml and XSLT 2.0 ISBN Function Library#

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

###Calculate ISBN Check Digits###

ISBN **check digits** are used to prevent transcription errors.  

ISBN-10 check digits are calculated as follows: 

    j = ( [a b c d e f g h i] * [1 2 3 4 5 6 7 8 9] ) mod 11 

ISBN-13 check digits are calculated as follows: 

    m = ( [a b c d e f g h i j k l] * [1 3 1 3 1 3 1 3 1 3 1 3] ) mod 10

The above examples came from this [hahnlibrary ISBN Check Digit Calculator](http://www.hahnlibrary.net/libraries/isbncalc.html) (that was developed by someone else)

Here is an example of how to calculate the check digit for an ISBN (10 or 13 digit): 

    xquery version "1.0-ml";
    
    import module namespace isbn = "http://github.com/holmesw/isbn" at "/xqy/modules/isbn.xqy";
    
    isbn:isbn-13-check-digit("9781234567897"), 
    (: the output of the above function call is: "7" :)
    
    isbn:isbn-13-check-digit("978-1-23456-789-7"), 
    (: the output of the above function call is: "7" :)
    
    isbn:isbn-10-check-digit("123456789X"), 
    (: the output of the above function call is: "X" :)
    
    isbn:isbn-10-check-digit("1-23456-789-X")
    (: the output of the above function call is: "X" :)

###Convert ISBN-10 to ISBN-13###

The **ISBN-13** version of an ISBN-10 is "978", then take the first 9 digits of the ISBN-10, finally add the ISBN-13 check digit.  

Here is an example of how to convert ISBN-10 to ISBN-13: 

    xquery version "1.0-ml";
    
    import module namespace isbn = "http://github.com/holmesw/isbn" at "/xqy/modules/isbn.xqy";
    
    isbn:isbn10-to-isbn13("123456789X"), 
    (: the output of the above function call is: "978-1-23456-789-7" :)
    
    isbn:isbn10-to-isbn13("1-23456-789-X")
    (: the output of the above function call is: "978-1-23456-789-7" :)

###Convert ISBN-13 to ISBN-10###

To convert ISBN-13 to **ISBN-10**, first remove the first three digits (usually "978"), then take the next 9 digits of the ISBN-13, finally add the ISBN-10 check digit.  

Here is an example of how to convert ISBN-13 to ISBN-10: 

    xquery version "1.0-ml";
    
    import module namespace isbn = "http://github.com/holmesw/isbn" at "/xqy/modules/isbn.xqy";
    
    isbn:isbn13-to-isbn10("9781234567897"), 
    (: the output of the above function call is: "1-23456-789-X" :)
    
    isbn:isbn13-to-isbn10("978-1-23456-789-7")
    (: the output of the above function call is: "1-23456-789-X" :)

###XQuery Unit Tests###


The XQuery has been tested using [xray (by Rob Whitby)](https://github.com/robwhitby/xray).  
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

The above XSLT, can be used to transform this XML document: 

    <?xml version="1.0" encoding="UTF-8"?>
    <isbns>
        <isbn13format>9781234567897</isbn13format>
        <isbn13format>978-1-23456-789-7</isbn13format>
        <isbn13prepare>9781234567897</isbn13prepare>
        <isbn13prepare>978-1-23456-789-7</isbn13prepare>
        <isbn13checkdigit>9781234567897</isbn13checkdigit>
        <isbn13checkdigit>978-1-23456-789-7</isbn13checkdigit>
        <isbn13toisbn10>9781234567897</isbn13toisbn10>
        <isbn13toisbn10>978-1-23456-789-7</isbn13toisbn10>
        <isbn10format>123456789X</isbn10format>
        <isbn10format>1-23456-789-X</isbn10format>
        <isbn10prepare>123456789X</isbn10prepare>
        <isbn10prepare>1-23456-789-X</isbn10prepare>
        <isbn10checkdigit>123456789X</isbn10checkdigit>
        <isbn10checkdigit>1-23456-789-X</isbn10checkdigit>
        <isbn10toisbn13>123456789X</isbn10toisbn13>
        <isbn10toisbn13>1-23456-789-X</isbn10toisbn13>
    </isbns>

Into this XML document: 

    <?xml version="1.0" encoding="UTF-8"?>
    <isbns>
        <isbn-13-format>978-1-23456-789-7</isbn-13-format>
        <isbn-13-format>978-1-23456-789-7</isbn-13-format>
        <isbn-13-prepare>9781234567897</isbn-13-prepare>
        <isbn-13-prepare>9781234567897</isbn-13-prepare>
        <isbn-13-check-digit>7</isbn-13-check-digit>
        <isbn-13-check-digit>7</isbn-13-check-digit>
        <isbn-13-to-isbn-10>1-23456-789-X</isbn-13-to-isbn-10>
        <isbn-13-to-isbn-10>1-23456-789-X</isbn-13-to-isbn-10>
        <isbn-10-format>1-23456-789-X</isbn-10-format>
        <isbn-10-format>1-23456-789-X</isbn-10-format>
        <isbn-10-prepare>123456789X</isbn-10-prepare>
        <isbn-10-prepare>123456789X</isbn-10-prepare>
        <isbn-10-check-digit>X</isbn-10-check-digit>
        <isbn-10-check-digit>X</isbn-10-check-digit>
        <isbn-10-to-isbn-13>978-1-23456-789-7</isbn-10-to-isbn-13>
        <isbn-10-to-isbn-13>978-1-23456-789-7</isbn-10-to-isbn-13>
    </isbns>
