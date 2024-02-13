package terminal_fps

import "base:runtime"
import "core:fmt"
import "core:os"
import "core:path/filepath"

// The main game camera.
Camera :: struct {
	// The position of the camera in the game map.
	position:   [2]f32,

	// The rotation of the camera relative to the positive Y-axis of the game map.
	rotation:   f32,

	// The near plane which defines how close something can be before it won't be rendered.
	near_plane: f32,

	// The far plane which defines how far something can be before it won't be rendered.
	far_plane:  f32,
}

// An enumeration of known types of game map tiles.
GameMapTile :: enum {
	// An air tile.
	AIR,

	// A wall tile.
	WALL,
}

// The main game map structure.
GameMap :: struct {
	// The width of the game map, in tiles.
	width:  i32,

	// The height of the game map, in tiles.
	height: i32,

	// The tiles in the game map.
	tiles:  [dynamic]GameMapTile,
}

create_game_map :: proc(
	width: i32,
	height: i32,
) -> (
	result: ^GameMap,
	error: runtime.Allocator_Error,
) {
	r := new(GameMap) or_return
	r.width = width
	r.height = height
	for x in 0 ..< (width * height) {
		append(&r.tiles, GameMapTile.AIR)
	}
	return r, nil
}

destroy_game_map :: proc(game_map: ^GameMap) {
	if game_map == nil {
		return
	}
	free(game_map)
}

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
	game_map, err := create_game_map(10, 10)
	if err != nil {
		panic("Failed to allocate game map")
	}
	fmt.println(fmt.aprintf("We created a %dx%d game map!", game_map.width, game_map.height))
	destroy_game_map(game_map)
	fmt.println("Goodbye!")
}
