xquery version "1.0-ml";

module namespace test = "http://github.com/robwhitby/xray/test";

import module namespace isbn = 
    "http://github.com/holmesw/isbn" at 
    "/xqy/modules/isbn.xqy";
import module namespace assert = 
    "http://github.com/robwhitby/xray/assertions" at 
    "/xray/src/assertions.xqy";

declare function isbn-format-isbn13-prepared() 
{
    assert:equal(
        text { isbn:format-isbn("9781234567897") }, 
        text { "978-1-23456-789-7" }
    )
};

declare function isbn-format-isbn13-formatted() 
{
    assert:equal(
        text { isbn:format-isbn("978-1-23456-789-7") }, 
        text { "978-1-23456-789-7" }
    )
};

declare function isbn-prepare-isbn13-prepared() 
{
    assert:equal(
        text { isbn:prepare-isbn("9781234567897") }, 
        text { "9781234567897" }
    )
};

declare function isbn-prepare-isbn13-formatted() 
{
    assert:equal(
        text { isbn:prepare-isbn("978-1-23456-789-7") }, 
        text { "9781234567897" }
    )
};

declare function isbn-check-digit-isbn13-prepared() 
{
    assert:equal(
        text { isbn:isbn-13-check-digit("9781234567897") }, 
        text { "7" }
    )
};

declare function isbn-check-digit-isbn13-formatted() 
{
    assert:equal(
        text { isbn:isbn-13-check-digit("978-1-23456-789-7") }, 
        text { "7" }
    )
};

declare function isbn-13-to-10-isbn13-prepared() 
{
    assert:equal(
        text { isbn:isbn13-to-isbn10("978-1-23456-789-7") }, 
        text { "1-23456-789-X" }
    )
};

declare function isbn-13-to-isbn10-isbn13-formatted() 
{
    assert:equal(
        text { isbn:isbn13-to-isbn10("978-1-23456-789-7") }, 
        text { "1-23456-789-X" }
    )
};

declare function isbn-format-isbn10-prepared() 
{
    assert:equal(
        text { isbn:format-isbn("1-23456-789-X") }, 
        text { "1-23456-789-X" }
    )
};

declare function isbn-format-isbn10-formatted() 
{
    assert:equal(
        text { isbn:format-isbn("1-23456-789-X") }, 
        text { "1-23456-789-X" }
    )
};

declare function isbn-prepare-isbn10-prepared() 
{
    assert:equal(
        text { isbn:prepare-isbn("123456789X") }, 
        text { "123456789X" }
    )
};

declare function isbn-prepare-isbn10-formatted() 
{
    assert:equal(
        text { isbn:prepare-isbn("1-23456-789-X") }, 
        text { "123456789X" }
    )
};

declare function isbn-check-digit-isbn10-prepared() 
{
    assert:equal(
        text { isbn:isbn-10-check-digit("123456789X") }, 
        text { "X" }
    )
};

declare function isbn-check-digit-isbn10-formatted() 
{
    assert:equal(
        text { isbn:isbn-10-check-digit("1-23456-789-X") }, 
        text { "X" }
    )
};

declare function isbn-10-to-13-isbn10-prepared() 
{
    assert:equal(
        text { isbn:isbn10-to-isbn13("123456789X") }, 
        text { "978-1-23456-789-7" }
    )
};

declare function isbn-10-to-isbn-13-isbn10-formatted() 
{
    assert:equal(
        text { isbn:isbn10-to-isbn13("1-23456-789-X") }, 
        text { "978-1-23456-789-7" }
    )
};

