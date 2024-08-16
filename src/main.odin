package terminal_fps

//-- Core Libraries
import "core:fmt"
import "core:os"

/*
A status code that can be returned to the operating system to indicate success.
*/
EXIT_SUCCESS :: 0

/*
A status code that can be returned to the operating system to indicate failure.
*/
EXIT_FAILURE :: 1

/*
The program entry point.
*/
main :: proc() {
    fmt.println("Hello, Odin!")
    os.exit(EXIT_SUCCESS)
}
