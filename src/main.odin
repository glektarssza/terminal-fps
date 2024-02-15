package terminal_fps

import "core:fmt"
import "core:os"
import "core:path/filepath"

// Get the path to the executable.
get_executable_path :: proc() -> string {
    return filepath.join({os.get_current_directory(), os.args[0]})
}

// Get the path to the directory of the executable.
get_executable_directory :: proc() -> string {
    return filepath.dir(get_executable_path())
}

// The program entry point.
main :: proc() {
    hello := fmt.aprintf("Hello world from \"%s\"!", get_executable_path())
    fmt.println(hello)
    fmt.println("We were run with...")
    for arg, i in os.args {
        formatted_arg := fmt.aprintf("\t%d: %s", i, arg)
        fmt.println(formatted_arg)
    }

    registry, err := create_tile_type_registry()
    if err != nil {
        panic("Failed to create game map tile registry")
    }

    fmt.println("We built a game map tile registry with...")
    for _, v in registry.tile_types {
        fmt.println(fmt.aprintf("\t%d: %s - %s", v.id, v.alias, v.name))
    }

    fmt.println("Goodbye!")
}
