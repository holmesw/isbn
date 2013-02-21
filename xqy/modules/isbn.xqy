(:~
 : XQuery library module containing functions to 
 : handle ISBNs
 : 
 : @see http://en.wikipedia.org/wiki/International_Standard_Book_Number
 : 
 : @author holmesw
 :)
xquery version "1.0-ml";

module namespace isbn = "http://github.com/holmesw/isbn";

(:~
 : format ISBN
 : 
 : @author holmesw
 : 
 : @param $isbn the ISBN
 : @return the formatted ISBN
 :)
declare function format-isbn(
    $isbn as xs:string
) as xs:string? 
{
    format-prepared-isbn(
      prepare-isbn($isbn)
    )
};

(:~
 : prepare ISBN
 : remove characters not in 0-9, A-Z or a-z
 : uses a regex to do this
 : 
 : @see http://www.regular-expressions.info/reference.html
 : 
 : @author holmesw
 : 
 : @param $isbn the ISBN
 : @return the prepared ISBN
 :)
declare function prepare-isbn(
    $isbn as xs:string
) as xs:string? 
{
    fn:replace($isbn, "(ISBN)?[^0-9A-Za-z]", "")
};

(:~
 : format prepared ISBN
 : 
 : @author holmesw
 : 
 : @param $isbn the prepared ISBN
 : @return the formatted ISBN
 :)
declare private function format-prepared-isbn(
    $isbn as xs:string
) as xs:string? 
{
    xdmp:apply(
        xdmp:function(
            xs:QName(
                fn:concat(
                    "isbn:format-isbn-", 
                    fn:string(
                        fn:string-length(
                            $isbn
                        )
                    )
                )
            )
        )[fn:string-length($isbn) = (10, 13)], 
        $isbn
    )
};

(:~
 : format ISBN-13
 : 
 : @author holmesw
 : 
 : @param $isbn the ISBN-13
 : @return the formatted ISBN-13
 :)
declare private function format-isbn-13(
    $isbn as xs:string
) as xs:string? {
    (: 13 digit ISBN code :)
    fn:replace($isbn, "(.{3})(.{1})(.{5})(.{3})(.{1})", "$1-$2-$3-$4-$5")[
        fn:starts-with($isbn, "978")
    ]
};

(:~
 : format ISBN-10
 : 
 : @author holmesw
 : 
 : @param $isbn the ISBN-10
 : @return the formatted ISBN-10
 :)
declare private function format-isbn-10(
    $isbn as xs:string
) as xs:string? 
{
    (: 10 digit ISBN code :)
    fn:replace($isbn, "(.{1})(.{5})(.{3})(.{1})", "$1-$2-$3-$4")
};

(:~
 : convert ISBN-13 to ISBN-10
 : 
 : @author holmesw
 : 
 : @param $isbn the ISBN-13 to convert
 : @return the formatted ISBN-10
 :)
declare function isbn13-to-isbn10(
    $isbn as xs:string
) as xs:string 
{
    format-isbn(
        fn:concat(
            isbn-9($isbn), 
            isbn-10-check-digit(
                $isbn
            )
        )
    )
};

(:~
 : convert ISBN-10 to ISBN-13
 : 
 : @author holmesw
 : 
 : @param $isbn the ISBN-10 to convert
 : @return the formatted ISBN-13
 :)
declare function isbn10-to-isbn13(
    $isbn as xs:string
) as xs:string 
{
    format-isbn(
        fn:concat(
            isbn-12($isbn), 
            isbn-13-check-digit(
                $isbn
            )
        )
    )
};

(:~
 : ISBN 13 Check Digit
 : 
 : @see http://isbn-information.com/isbn-check-digit.html
 : 
 : @author holmesw
 : 
 : @param $isbn the ISBN-13
 : @return the ISBN-13 check digit
 :)
declare function isbn-13-check-digit(
    $isbn as xs:string 
) as xs:string? 
{
    isbn-13-check-digit-display(
        10 - math:fmod(
            fn:sum(
                isbn-13-apply-check-digit-weights(
                    split-isbn(
                        isbn-12(
                            $isbn
                        )
                    ), 
                    12
                )
            ), 
            10
        )
    )
};

(:~
 : Display ISBN 13 Check Digit
 : 
 : @author holmesw
 : 
 : @param $checkdigit the ISBN-13 check digit
 : @return the ISBN-13 check digit
 :)
declare private function isbn-13-check-digit-display(
    $checkdigit as xs:double 
) as xs:string? 
{
    if ($checkdigit le 9) then fn:string($checkdigit)
    else "X"
};

(:~
 : ISBN 10 Check Digit
 : 
 : @see http://en.wikipedia.org/wiki/Check_digit#ISBN_10
 : 
 : @author holmesw
 : 
 : @param $isbn the ISBN-10
 : @return the ISBN-10 check digit
 :)
declare function isbn-10-check-digit(
    $isbn as xs:string 
) as xs:string? 
{
    isbn-10-check-digit-display(
        11 - math:fmod(
            fn:sum(
                isbn-10-apply-check-digit-weights(
                    split-isbn(
                        isbn-9(
                            $isbn
                        )
                    ), 
                    9
                )
            ), 
            11
        )
    )
};

(:~
 : Display ISBN 10 Check Digit
 : 
 : @author holmesw
 : 
 : @param $checkdigit the ISBN-10 check digit
 : @return the ISBN-10 check digit
 :)
declare private function isbn-10-check-digit-display(
    $checkdigit as xs:double 
) as xs:string? 
{
    if ($checkdigit ge 11) then "0"
    else if ($checkdigit le 9) then fn:string($checkdigit)
    else "X"
};

(:~
 : ISBN 9 (for ISBN-10 Check Digit)
 : 
 : @author holmesw
 : 
 : @param $isbn the ISBN
 : @return the ISBN9 string
 :)
declare private function isbn-9(
    $isbn as xs:string 
) as xs:string? 
{
    let $isbn as xs:string := 
        validate-isbn-length($isbn)
    return
        fn:substring(
            $isbn, 
            if (fn:string-length($isbn) = (9, 10)) then 1 else 4, 
            9
        )
};

(:~
 : ISBN 12 (for ISBN-13 Check Digit)
 : 
 : @author holmesw
 : 
 : @param $isbn the ISBN
 : @return the ISBN9 string
 :)
declare private function isbn-12(
    $isbn as xs:string 
) as xs:string? 
{
    let $isbn as xs:string := 
        validate-isbn-length($isbn)
    return
        fn:substring(
            fn:concat(
                if (fn:string-length($isbn) = (9, 10)) then "978" else "", 
                $isbn
            ), 
            1, 
            12
        )
};

(:~
 : Apply ISBN-10 Check Digit Weights (recursive)
 : 
 : @author holmesw
 : 
 : @param $isbn the ISBN
 : @return some numbers
 :)
declare private function isbn-10-apply-check-digit-weights(
    $isbn-chars as xs:string*, 
    $pos as xs:unsignedInt
) as xs:double 
{
    if ($pos gt 1) then
        fn:number(
            (
                $isbn-chars
            )[xs:integer($pos)]
        ) * 
        (
            10 - $pos + 1
        ) + 
        isbn-10-apply-check-digit-weights(
            $isbn-chars, 
            ($pos - 1)
        )
    else
        fn:number(
            (
                $isbn-chars[1]
            )
        ) * 10
};

(:~
 : Apply ISBN-13 Check Digit Weights (recursive)
 : 
 : @author holmesw
 : 
 : @param $isbn the ISBN
 : @return some numbers
 :)
declare private function isbn-13-apply-check-digit-weights(
    $isbn-chars as xs:string*, 
    $pos as xs:unsignedInt
) as xs:double* 
{
   if ($pos gt 1) then
        fn:number(
            (
                $isbn-chars
            )[xs:integer($pos)]
        ) * 
        (
            (3, 1)[xs:integer(math:fmod($pos, 2) + 1)][1]
        ) + 
        isbn-13-apply-check-digit-weights(
            $isbn-chars, 
            ($pos - 1)
        )
    else
        fn:number(
            (
                $isbn-chars[1]
            )
        ) * 1
};

(:~
 : Validate prepared ISBN 
 : should contain 9, 10, 12 or 13 chars
 : 
 : @author holmesw
 : 
 : @param $isbn the ISBN
 : @return ISBN
 :)
declare private function validate-isbn-length(
    $isbn as xs:string
) as xs:string 
{
    fn:string(
        prepare-isbn(
            $isbn
        )[fn:string-length(.) = (9, 10, 12, 13)]
    )
};

(:~
 : split ISBN into single-length strings
 : 
 : @author holmesw
 : 
 : @param $isbn the ISBN
 : @return some single-length strings
 :)
declare private function split-isbn(
    $isbn as xs:string
) as xs:string* 
{
    let $isbn as xs:string := 
        validate-isbn-length($isbn)
    let $len as xs:unsignedInt := 
        fn:string-length($isbn)
    return
        fn:tokenize(
            fn:replace(
                $isbn, 
                fn:concat(
                    "(.{1})(.{1})(.{1})(.{1})(.{1})(.{1})(.{1})(.{1})(.{1})", 
                    "(.{1})(.{1})(.{1})"[$len = (12, 13)]
                ), 
                fn:concat(
                    "$1-$2-$3-$4-$5-$6-$7-$8-$9", 
                    "-$10-$11-$12"[$len = (12, 13)]
                )
            ), 
            "-"
        )
};

