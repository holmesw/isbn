(:~
 : XQuery library module containing functions to 
 : handle ISBNs
 : 
 : @see http://en.wikipedia.org/wiki/International_Standard_Book_Number
 : @see http://www.regular-expressions.info/reference.html
 : 
 : Unless required by applicable law or agreed to in writing, software
 : distributed under the License is distributed on an "AS IS" BASIS,
 : WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 : See the License for the specific language governing permissions and
 : limitations under the License.
 : 
 : @author holmesw
 :)
xquery version "3.0";

module namespace isbn = "http://github.com/holmesw/isbn";

declare default function namespace "http://github.com/holmesw/isbn";

declare %private variable $isbn:empty-sequence as function(*) := 
    function ($isbn as xs:string) as empty-sequence() {()};

declare %private variable $isbn:format-isbn-13 as function(*) := 
    fn:function-lookup(xs:QName("isbn:format-isbn-13"), 1);

declare %private variable $isbn:format-isbn-10 as function(*) := 
    fn:function-lookup(xs:QName("isbn:format-isbn-10"), 1);

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
    select-higher-order-function(
        $isbn, 
        $isbn:format-isbn-13, 
        $isbn:format-isbn-10, 
        $isbn:empty-sequence
    ) ( prepare-isbn($isbn) )
};

(:~
 : prepare ISBN
 : remove characters not in 0-9, A-Z or a-z
 : uses a regex to do this
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
    fn:replace(fn:upper-case($isbn), "(ISBN)?[^0-9A-Za-z]", "")
};

(:~
 : select higher order function 
 : based on ISBN length
 : 
 : @author holmesw
 : 
 : @param $isbn the prepared ISBN
 : @return a function
 :)
declare %private function select-higher-order-function(
    $isbn as xs:string, 
    $fn-13 as function(*), 
    $fn-10 as function(*), 
    $default as function(*)
) as function(*) 
{
    switch (fn:string-length(prepare-isbn($isbn)))
        case xs:integer(13) return $fn-13
        case xs:integer(10) return $fn-10
        default return $default
};

(:~
 : format ISBN-13
 : uses a regex to do this
 : 
 : @author holmesw
 : 
 : @param $isbn the ISBN-13
 : @return the formatted ISBN-13
 :)
declare %private function format-isbn-13(
    $isbn as xs:string
) as xs:string? 
{
    (: 13 digit ISBN code :)
    fn:replace($isbn, "(.{3})(.{1})(.{5})(.{3})(.{1})", "$1-$2-$3-$4-$5")[
        fn:starts-with($isbn, "978")
    ]
};

(:~
 : format ISBN-10
 : uses a regex to do this
 : 
 : @author holmesw
 : 
 : @param $isbn the ISBN-10
 : @return the formatted ISBN-10
 :)
declare %private function format-isbn-10(
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

declare %private variable $isbn:isbn-13-check-digit as function(*) := 
    fn:function-lookup(xs:QName("isbn:isbn-13-check-digit"), 1);

declare %private variable $isbn:isbn-10-check-digit as function(*) := 
    fn:function-lookup(xs:QName("isbn:isbn-10-check-digit"), 1);

(:~
 : ISBN Check Digit
 : 
 : @author holmesw
 : 
 : @param $isbn the ISBN
 : @return the ISBN check digit
 :)
declare function isbn-check-digit(
    $isbn as xs:string 
) as xs:string? 
{
    select-higher-order-function(
        $isbn, 
        $isbn:isbn-13-check-digit, 
        $isbn:isbn-10-check-digit, 
        $isbn:empty-sequence
    ) ( $isbn )
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
        let $check-digit as xs:unsignedLong := 
            xs:unsignedLong(
                isbn-13-apply-check-digit-weights(
                    split-isbn(
                        isbn-12($isbn)
                    ), 
                    xs:unsignedInt(12)
                ) mod 10
            )
        return
            if ($check-digit eq 0) then 0
            else 10 - $check-digit
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
declare %private function isbn-13-check-digit-display(
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
        11 - (
            isbn-10-apply-check-digit-weights(
                split-isbn(
                    isbn-9($isbn)
                ), 
                xs:unsignedInt(9)
            ) mod 11
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
declare %private function isbn-10-check-digit-display(
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
declare %private function isbn-9(
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
declare %private function isbn-12(
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
declare %private function isbn-10-apply-check-digit-weights(
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
            xs:unsignedInt($pos - 1)
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
declare %private function isbn-13-apply-check-digit-weights(
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
            (3, 1)[xs:integer(($pos mod 2) + 1)][1]
        ) + 
        isbn-13-apply-check-digit-weights(
            $isbn-chars, 
            xs:unsignedInt($pos - 1)
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
declare %private function validate-isbn-length(
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
 : borrowed from functx:chars function
 : @see http://www.xqueryfunctions.com/xq/functx_chars.html
 : 
 : @author holmesw
 : 
 : @param $isbn the ISBN
 : @return some single-length strings
 :)
declare %private function split-isbn(
    $isbn as xs:string
) as xs:string* 
{
    for $codepoint as xs:integer in 
        fn:string-to-codepoints(
            validate-isbn-length($isbn)
        ) 
    return 
        fn:codepoints-to-string($codepoint)
};

(:~
 : ensure ISBN is valid length and ends with check digit
 : 
 : @author holmesw
 : 
 : @param $isbn the ISBN
 : @return true/false
 :)
declare function is-valid-isbn(
    $isbn as xs:string
) as xs:boolean 
{
    is-valid-isbn-length($isbn) and 
    is-valid-isbn-check-digit($isbn)
};

(:~
 : ensure ISBN is valid length (10 or 13 chars)
 : 
 : @author holmesw
 : 
 : @param $isbn the ISBN
 : @return true/false
 :)
declare %private function is-valid-isbn-length(
    $isbn as xs:string
) as xs:boolean 
{
    fn:string-length(prepare-isbn($isbn)) = (10, 13)
};

(:~
 : ensure ISBN ends with valid check digit
 : 
 : @author holmesw
 : 
 : @param $isbn the ISBN
 : @return true/false
 :)
declare %private function is-valid-isbn-check-digit(
    $isbn as xs:string
) as xs:boolean 
{
    fn:ends-with(
        prepare-isbn($isbn), 
        isbn-check-digit($isbn)
    )
};
