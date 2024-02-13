package terminal_fps

import "base:runtime"
import "core:strings"

/*
An enumeration of known errors that can come from registry-related operations.
*/
Registry_Error_Code :: enum u8 {
	// A value indicating there has been no errors.
	No_Error            = 0,

	// A value indicating an error occurred inside an `Allocator`.
	Allocator_Error     = 1,

	// A value indicating a value was not a valid `Registry_ID`.
	Invalid_Registry_ID = 2,
}

/*
A structure that holds error information for registry-related operations.
*/
Registry_Error :: struct {
	/*
    The error code that is being returned.
    */
	code:                 Registry_Error_Code,

	/*
    An additional error code if the `code` field is
    `Registry_Error_Code.Allocator_Error`.
    */
	allocator_error_code: Maybe(runtime.Allocator_Error),
}

@(private = "file")
create_registry_error_from_code :: proc(code: Registry_Error_Code) -> Registry_Error {
	return Registry_Error{code = code, allocator_error_code = nil}
}

@(private = "file")
create_registry_error_from_allocator_error :: proc(
	code: Registry_Error_Code,
	allocator_error_code: runtime.Allocator_Error,
) -> Registry_Error {
	return Registry_Error{code, allocator_error_code}
}

@(private = "file")
create_registry_error :: proc {
	create_registry_error_from_code,
	create_registry_error_from_allocator_error,
}

/*
A structure that represents a unique identifier within a `Registry`.

This ID is a `string` with the following structure (in Backus-Naur form):

```
<registry-id> ::= <namespace> ":" <location>
<namespace> ::= <letter> | <namespace> <identifier-character>
<location> ::= <id-component> | <path-component> "/" <id-component>
<path-component> ::= <letter> | <path-component> <identifier-character>
<id-component> ::= <letter> | <id-component> <identifier-character>
<identifier-character> ::= <letter> | <digit> | "-" | "_"
<letter> ::= "A" | "B" | "C" | "D" | "E" | "F" | "G" | "H" | "I" | "J" | "K"
    | "L" | "M" | "N" | "O" | "P" | "Q" | "R" | "S" | "T" | "U" | "V" | "W"
    | "X" | "Y" | "Z" | "a" | "b" | "c" | "d" | "e" | "f" | "g" | "h" | "i"
    | "j" | "k" | "l" | "m" | "n" | "o" | "p" | "q" | "r" | "s" | "t" | "u"
    | "v" | "w" | "x" | "y" | "z"
<digit> ::= "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"
```
*/
Registry_ID :: struct {
	// The namespace component of the ID.
	namespace: string,

	// The location component of the ID.
	location:  string,
}

/*
Create a new `Registry_ID` from the given namespace and location combination.
*/
create_registry_id_default :: proc(namespace: string, location: string) -> Registry_ID {
	return Registry_ID{namespace, location}
}

/*
Create a new `Registry_ID` from the given string.
*/
create_registry_id_from_string :: proc(
	registry_id: string,
) -> (
	result: Registry_ID,
	error: Registry_Error,
) {
	res, err := strings.split_n(registry_id, ":", 2)
	if err != nil {
		error = create_registry_error(Registry_Error_Code.Allocator_Error, err)
		return
	}
	if len(res) < 2 {
		error = create_registry_error(Registry_Error_Code.Invalid_Registry_ID)
		return
	}
	result = create_registry_id_default(res[0], res[1])
	return
}

/*
Create a new `Registry_ID`.
*/
create_registry_id :: proc {
	create_registry_id_default,
	create_registry_id_from_string,
}

/*
A structure that can hold a collection of data of a given type.

The data can by accessed by a unqiue ID, known as a "registry ID". This ID is a
`string` with the following structure (in Backus-Naur form):

```
<registry-id> ::= <namespace> ":" <location>
<namespace> ::= <letter> | <namespace> <identifier-character>
<location> ::= <id-component> | <path-component> "/" <id-component>
<path-component> ::= <letter> | <path-component> <identifier-character>
<id-component> ::= <letter> | <id-component> <identifier-character>
<identifier-character> ::= <letter> | <digit> | "-" | "_"
<letter> ::= "A" | "B" | "C" | "D" | "E" | "F" | "G" | "H" | "I" | "J" | "K"
    | "L" | "M" | "N" | "O" | "P" | "Q" | "R" | "S" | "T" | "U" | "V" | "W"
    | "X" | "Y" | "Z" | "a" | "b" | "c" | "d" | "e" | "f" | "g" | "h" | "i"
    | "j" | "k" | "l" | "m" | "n" | "o" | "p" | "q" | "r" | "s" | "t" | "u"
    | "v" | "w" | "x" | "y" | "z"
<digit> ::= "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"
```
*/
Registry :: struct {}
