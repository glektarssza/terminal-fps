package utils

//-- Core Libraries
import "core:strings"
import "core:testing"
import "core:text/match"

/*
Expect a value to equal another value.

### Parameters ###

* `t` - The testing object.
* `value` - The value to test.
* `expected` - The value to test the value against.
*/
expect_equal :: proc(t: ^testing.T, value: $T, expected: $U) {
    testing.expectf(
        t,
        value == expected,
        "Expected \"%s\" to be \"%s\"",
        value,
        expected,
    )
}

/*
Expect a value to not equal another value.

### Parameters ###

* `t` - The testing object.
* `value` - The value to test.
* `expected` - The value to test the value against.
*/
expect_not_equal :: proc(t: ^testing.T, value: $T, expected: $U) {
    testing.expectf(
        t,
        value != expected,
        "Expected \"%s\" to not be \"%s\"",
        value,
        expected,
    )
}

/*
Expect a value to be `nil`.

### Parameters ###

* `t` - The testing object.
* `value` - The value to test.
*/
expect_nil :: proc(t: ^testing.T, value: any) {
    testing.expectf(t, value == nil, "Expected \"%s\" to be \"nil\"", value)
}

/*
Expect a value to not be `nil`.

### Parameters ###

* `t` - The testing object.
* `value` - The value to test.
*/
expect_not_nil :: proc(t: ^testing.T, value: any) {
    testing.expectf(
        t,
        value != nil,
        "Expected \"%s\" to not be \"nil\"",
        value,
    )
}

/*
Expect a value to be an empty string.

### Parameters ###

* `t` - The testing object.
* `value` - The value to test.
*/
expect_empty_string :: proc(t: ^testing.T, value: string) {
    testing.expectf(t, value == "", "Expected \"%s\" to be \"\"", value)
}

/*
Expect a value to not be an empty string.

### Parameters ###

* `t` - The testing object.
* `value` - The value to test.
*/
expect_not_empty_string :: proc(t: ^testing.T, value: string) {
    testing.expectf(t, value != "", "Expected \"%s\" to not be \"\"", value)
}

/*
Expect a value to be a string containing another string.

### Parameters ###

* `t` - The testing object.
* `value` - The value to test.
* `needle` - The value to check for.
*/
expect_string_contains :: proc(t: ^testing.T, value: string, needle: string) {
    testing.expectf(
        t,
        strings.contains(value, needle),
        "Expected \"%s\" to contain \"%s\"",
        value,
        needle,
    )
}

/*
Expect a value to be a string not containing another string.

### Parameters ###

* `t` - The testing object.
* `value` - The value to test.
* `needle` - The value to check for.
*/
expect_string_not_contains :: proc(
    t: ^testing.T,
    value: string,
    needle: string,
) {
    testing.expectf(
        t,
        !strings.contains(value, needle),
        "Expected \"%s\" to not contain \"%s\"",
        value,
        needle,
    )
}

/*
Expect a value to be a string matching a pattern.

### Parameters ###

* `t` - The testing object.
* `value` - The value to test.
* `pattern` - The value to match against.
*/
expect_string_matches :: proc(t: ^testing.T, value: string, pattern: string) {
    p := strings.clone(value)
    caps := [match.MAX_CAPTURES]match.Match{}
    _, ok := match.gmatch(&p, pattern, &caps)
    testing.expectf(t, ok, "Expected \"%s\" to match \"%s\"", value, pattern)
}

/*
Expect a value to be a string not matching a pattern.

### Parameters ###

* `t` - The testing object.
* `value` - The value to test.
* `pattern` - The value to match against.
*/
expect_string_not_matches :: proc(
    t: ^testing.T,
    value: string,
    pattern: string,
) {
    p := strings.clone(value)
    caps := [match.MAX_CAPTURES]match.Match{}
    _, ok := match.gmatch(&p, pattern, &caps)
    testing.expectf(
        t,
        !ok,
        "Expected \"%s\" to not match \"%s\"",
        value,
        pattern,
    )
}
