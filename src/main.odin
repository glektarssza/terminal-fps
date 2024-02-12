package terminal_fps

import "core:fmt"
import "core:os"

main :: proc() {
	hello := fmt.aprintf("Hello world from \"%s\"!", os.get_current_directory())
	fmt.println(hello)
	fmt.println("We were run with...")
	for arg, i in os.args {
		formatted_arg := fmt.aprintf("\t%d: %s", i, arg)
		fmt.println(formatted_arg)
	}
	fmt.println("Goodbye!")
}
