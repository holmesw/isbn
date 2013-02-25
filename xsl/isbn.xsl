<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:isbn="http://github.com/holmesw/isbn" 
    extension-element-prefixes=""
    exclude-result-prefixes="xsi xs fn isbn" 
    version="2.0">
    
    <xsl:function name="isbn:format-isbn" as="xs:string?">
        <xsl:param name="isbn" as="xs:string" />
        <xsl:sequence select="isbn:format-prepared-isbn(isbn:prepare-isbn($isbn))" />
    </xsl:function>
    
    <xsl:function name="isbn:prepare-isbn" as="xs:string?">
        <xsl:param name="isbn" as="xs:string" />
        <xsl:value-of select='fn:replace($isbn, "(ISBN)?[^0-9A-Za-z]", "")' />
    </xsl:function>
    
    <xsl:function name="isbn:format-prepared-isbn" as="xs:string?">
        <xsl:param name="isbn" as="xs:string" />
        <xsl:choose>
            <xsl:when test="fn:string-length($isbn) eq 13">
                <xsl:sequence select="isbn:format-isbn-13($isbn)" />
            </xsl:when>
            <xsl:when test="fn:string-length($isbn) eq 10">
                <xsl:sequence select="isbn:format-isbn-10($isbn)" />
            </xsl:when>
            <xsl:otherwise>
                <!-- BAD ISBN Pattern -->
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="isbn:format-isbn-13" as="xs:string?">
        <xsl:param name="isbn" as="xs:string" />
        <xsl:if test='fn:starts-with($isbn, "978")'>
            <xsl:value-of select='
                fn:replace(
                    $isbn, 
                    "(.{3})(.{1})(.{5})(.{3})(.{1})", 
                    "$1-$2-$3-$4-$5"
                )
            ' />
        </xsl:if>
    </xsl:function>
    
    <xsl:function name="isbn:format-isbn-10" as="xs:string?">
        <xsl:param name="isbn" as="xs:string" />
        <xsl:value-of select='
            fn:replace(
                $isbn, 
                "(.{1})(.{5})(.{3})(.{1})", 
                "$1-$2-$3-$4"
            )
        ' />
    </xsl:function>
    
    <xsl:function name="isbn:isbn10-to-isbn13" as="xs:string?">
        <xsl:param name="isbn" as="xs:string" />
        <xsl:sequence select='
            isbn:format-isbn(
                fn:concat(
                    isbn:isbn-12($isbn),
                    isbn:isbn-13-check-digit($isbn)
                )
            )
        ' />
    </xsl:function>
    
    <xsl:function name="isbn:isbn13-to-isbn10" as="xs:string?">
        <xsl:param name="isbn" as="xs:string" />
        <xsl:sequence select='
            isbn:format-isbn(
                fn:concat(
                    isbn:isbn-9($isbn), 
                    isbn:isbn-10-check-digit($isbn)
                )
            )
        ' />
    </xsl:function>
    
    <xsl:function name="isbn:isbn-13-check-digit" as="xs:string?">
        <xsl:param name="isbn" as="xs:string" />
        <xsl:sequence select='
            isbn:isbn-13-check-digit-display(
                10 - 
                (
                    fn:sum(
                        isbn:isbn-13-apply-check-digit-weights(
                            isbn:split-isbn(
                                isbn:isbn-12($isbn)
                            ),
                            xs:unsignedInt(12)
                        )
                    ) mod 10
                )
            )
        ' />
    </xsl:function>
    
    <xsl:function name="isbn:isbn-13-check-digit-display" as="xs:string?">
        <xsl:param name="checkdigit" as="xs:double" />
        <xsl:choose>
            <xsl:when test="$checkdigit le 9">
                <xsl:value-of select="fn:string($checkdigit)" />
            </xsl:when>
            <xsl:otherwise>X</xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="isbn:isbn-10-check-digit" as="xs:string?">
        <xsl:param name="isbn" as="xs:string" />
        <xsl:sequence select='
            isbn:isbn-10-check-digit-display(
                11 - 
                (
                    fn:sum(
                        isbn:isbn-10-apply-check-digit-weights(
                            isbn:split-isbn(
                                isbn:isbn-9($isbn)
                            ),
                            xs:unsignedInt(9)
                        )
                    ) mod 11
                )
            )
        ' />
    </xsl:function>
    
    <xsl:function name="isbn:isbn-10-check-digit-display" as="xs:string?">
        <xsl:param name="checkdigit" as="xs:double" />
        <xsl:choose>
            <xsl:when test="$checkdigit ge 11">0</xsl:when>
            <xsl:when test="$checkdigit le 9">
                <xsl:value-of select="fn:string($checkdigit)" />
            </xsl:when>
            <xsl:otherwise>X</xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="isbn:isbn-9" as="xs:string?">
        <xsl:param name="isbn-input" as="xs:string" />
        <xsl:variable name="isbn" as="xs:string">
            <xsl:value-of select="isbn:validate-isbn-length($isbn-input)" />
        </xsl:variable>
        <xsl:variable name="substring-length" as="xs:unsignedInt">
            <xsl:choose>
                <xsl:when test="fn:string-length($isbn) = (9, 10)">1</xsl:when>
                <xsl:otherwise>4</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="fn:substring($isbn, $substring-length, 9)" />
    </xsl:function>
    
    <xsl:function name="isbn:isbn-12" as="xs:string?">
        <xsl:param name="isbn-input" as="xs:string" />
        <xsl:variable name="isbn" as="xs:string">
            <xsl:value-of select="isbn:validate-isbn-length($isbn-input)" />
        </xsl:variable>
        <xsl:variable name="isbn-prefix" as="xs:string?">
            <xsl:choose>
                <xsl:when test="fn:string-length($isbn) = (9, 10)">978</xsl:when>
                <xsl:otherwise></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="fn:substring(fn:concat($isbn-prefix, $isbn), 1, 12)" />
    </xsl:function>
    
    <xsl:function name="isbn:isbn-10-apply-check-digit-weights" as="xs:double">
        <xsl:param name="isbn-chars" as="xs:string*" />
        <xsl:param name="pos" as="xs:unsignedInt" />
        <xsl:choose>
            <xsl:when test="$pos gt 1">
                <xsl:sequence select="
                    fn:number(
                        ( 
                            $isbn-chars 
                        )[xs:integer($pos)] 
                    ) * (10 - $pos + 1) + 
                    isbn:isbn-10-apply-check-digit-weights(
                        $isbn-chars, 
                        xs:unsignedInt($pos - 1)
                    )
                " />
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="fn:number(($isbn-chars[1])) * 10" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="isbn:isbn-13-apply-check-digit-weights" as="xs:double">
        <xsl:param name="isbn-chars" as="xs:string*" />
        <xsl:param name="pos" as="xs:unsignedInt" />
        <xsl:choose>
            <xsl:when test="$pos gt 1">
                <xsl:sequence select="
                    fn:number(
                        (
                            $isbn-chars
                        )[xs:integer($pos)]
                    ) * ((3, 1)[xs:integer(($pos mod 2) + 1)][1]) + 
                    isbn:isbn-13-apply-check-digit-weights(
                        $isbn-chars, 
                        xs:unsignedInt($pos - 1)
                    )" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="fn:number(($isbn-chars[1])) * 1" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="isbn:validate-isbn-length" as="xs:string?">
        <xsl:param name="isbn" as="xs:string" />
        <xsl:variable name="prepared-isbn" as="xs:string">
            <xsl:sequence select="isbn:prepare-isbn($isbn)" />
        </xsl:variable>
        <xsl:if test="fn:string-length($prepared-isbn) = (9, 10, 12, 13)">
            <xsl:value-of select="$prepared-isbn" />
        </xsl:if>
    </xsl:function>
    
    <xsl:function name="isbn:split-isbn" as="xs:string*">
        <xsl:param name="isbn" as="xs:string" />
        <xsl:variable name="prepared-isbn" as="xs:string">
            <xsl:sequence select="isbn:validate-isbn-length($isbn)" />
        </xsl:variable>
        <xsl:variable name="prepared-isbn-len" as="xs:unsignedInt">
            <xsl:sequence select="fn:string-length($prepared-isbn)" />
        </xsl:variable>
        <xsl:variable name="replace-str-1" as="xs:string">
            <xsl:choose>
                <xsl:when test="$prepared-isbn-len = (9, 10)">
                    (.{1})(.{1})(.{1})(.{1})(.{1})(.{1})(.{1})(.{1})(.{1})
                </xsl:when>
                <xsl:otherwise>
                    (.{1})(.{1})(.{1})(.{1})(.{1})(.{1})(.{1})(.{1})(.{1})(.{1})(.{1})(.{1})
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="replace-str-2" as="xs:string">
            <xsl:choose>
                <xsl:when test="$prepared-isbn-len = (9, 10)">
                    $1-$2-$3-$4-$5-$6-$7-$8-$9
                </xsl:when>
                <xsl:otherwise>
                    $1-$2-$3-$4-$5-$6-$7-$8-$9-$10-$11-$12
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:sequence select="
           fn:tokenize(
               fn:replace(
                   $prepared-isbn, 
                   $replace-str-1, 
                   $replace-str-2
               ), 
               '-'
           )
        " />
    </xsl:function>
</xsl:stylesheet>
