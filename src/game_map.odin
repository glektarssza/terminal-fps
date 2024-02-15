package terminal_fps

import "base:runtime"

Game_Map_Tile_Registry_Error :: enum u8 {
    No_Error            = 0,
    Invalid_Registry    = 1,
    ID_Already_Taken    = 2,
    Alias_Already_Taken = 3,
    No_Such_ID          = 4,
    No_Such_Alias       = 5,
}

// A structure representing a type of tile in a game map.
Game_Map_Tile_Type :: struct {
    // The ID of the tile type. Must be unique among all other tile types.
    id:    u64,

    // An alias for the tile type. Must be unique among all other tile types.
    alias: Maybe(string),

    // The human-readable name of the tile type.
    name:  string,

    // Whether this type of tile is solid to the player.
    solid: bool,
}

// A registry of game map tile types.
Game_Map_Tile_Registry :: struct {
    // A map of tile type IDs to their definitions.
    tile_types:   map[u64]Game_Map_Tile_Type,

    // A map of tile aliases to their definitions.
    tile_aliases: map[string]u64,
}

// A structure which hols the main game map.
Game_Map :: struct {
    // The width of the game map.
    width:  i32,

    // The height of the game map.
    height: i32,

    // The tiles of the game map, stored in row-major order.
    tiles:  [dynamic]Game_Map_Tile_Type,
}

// Create a new registry for game map tile types.
create_tile_type_registry :: proc(
) -> (
    result: ^Game_Map_Tile_Registry,
    error: union {
        Game_Map_Tile_Registry_Error,
        runtime.Allocator_Error,
    },
) {
    r := new(Game_Map_Tile_Registry) or_return
    r.tile_types = make(map[u64]Game_Map_Tile_Type)
    r.tile_aliases = make(map[string]u64)
    err := populate_tile_type_registry_defaults(r)
    if err != Game_Map_Tile_Registry_Error.No_Error {
        destroy_tile_type_registry(r)
        return nil, err
    }
    return r, nil
}

// Destroy an existing registry for game map tile types
destroy_tile_type_registry :: proc(registry: ^Game_Map_Tile_Registry) {
    if registry == nil {
        return
    }
    delete(registry.tile_types)
    delete(registry.tile_aliases)
    free(registry)
}

// Register a tile type into a game map tile type registry.
register_tile_type :: proc(
    registry: ^Game_Map_Tile_Registry,
    tile_type: Game_Map_Tile_Type,
) -> Game_Map_Tile_Registry_Error {
    if registry == nil {
        return Game_Map_Tile_Registry_Error.Invalid_Registry
    }
    if tile_type.id in registry.tile_types {
        return Game_Map_Tile_Registry_Error.ID_Already_Taken
    }
    if tile_type.alias != nil && tile_type.alias.? in registry.tile_aliases {
        return Game_Map_Tile_Registry_Error.Alias_Already_Taken
    }
    registry.tile_types[tile_type.id] = tile_type
    if tile_type.alias != nil {
        registry.tile_aliases[tile_type.alias.?] = tile_type.id
    }
    return Game_Map_Tile_Registry_Error.No_Error
}

// Remove a tile type from a registry using its ID.
remove_registered_tile_type_by_id :: proc(
    registry: ^Game_Map_Tile_Registry,
    #any_int id: u64,
) -> Game_Map_Tile_Registry_Error {
    if registry == nil {
        return Game_Map_Tile_Registry_Error.Invalid_Registry
    }
    if id not_in registry.tile_types {
        return Game_Map_Tile_Registry_Error.No_Such_ID
    }
    delete_key(&registry.tile_types, id)
    return Game_Map_Tile_Registry_Error.No_Error
}

// Remove a tile type from a registry using its alias.
remove_registered_tile_type_by_alias :: proc(
    registry: ^Game_Map_Tile_Registry,
    alias: string,
) -> Game_Map_Tile_Registry_Error {
    if registry == nil {
        return Game_Map_Tile_Registry_Error.Invalid_Registry
    }
    if alias not_in registry.tile_aliases {
        return Game_Map_Tile_Registry_Error.No_Such_Alias
    }
    id := registry.tile_aliases[alias]
    return remove_registered_tile_type_by_id(registry, id)
}

// Remove a tile type from a registry.
remove_registered_tile_type :: proc {
    remove_registered_tile_type_by_id,
    remove_registered_tile_type_by_alias,
}

get_registered_tile_type_by_id :: proc(
    registry: ^Game_Map_Tile_Registry,
    #any_int id: u64,
) -> (
    tile: Game_Map_Tile_Type,
    error: Game_Map_Tile_Registry_Error,
) {
    if registry == nil {
        error = Game_Map_Tile_Registry_Error.Invalid_Registry
        return
    }
    if id not_in registry.tile_types {
        error = Game_Map_Tile_Registry_Error.No_Such_ID
        return
    }
    return registry.tile_types[id], nil
}

get_registered_tile_type_by_alias :: proc(
    registry: ^Game_Map_Tile_Registry,
    alias: string,
) -> (
    tile: Game_Map_Tile_Type,
    error: Game_Map_Tile_Registry_Error,
) {
    if registry == nil {
        error = Game_Map_Tile_Registry_Error.Invalid_Registry
        return
    }
    if alias not_in registry.tile_aliases {
        error = Game_Map_Tile_Registry_Error.No_Such_Alias
        return
    }
    id := registry.tile_aliases[alias]
    return get_registered_tile_type_by_id(registry, id)
}

get_registered_tile_type :: proc {
    get_registered_tile_type_by_id,
    get_registered_tile_type_by_alias,
}

// Populate the built-in game map tile types.
@(private = "file")
populate_tile_type_registry_defaults :: proc(
    registry: ^Game_Map_Tile_Registry,
) -> Game_Map_Tile_Registry_Error {
    if registry == nil {
        return Game_Map_Tile_Registry_Error.Invalid_Registry
    }
    register_tile_type(
        registry,
        Game_Map_Tile_Type {
            id = 1,
            alias = "terminal_fps:air",
            name = "Air",
            solid = false,
        },
    ) or_return
    register_tile_type(
        registry,
        Game_Map_Tile_Type {
            id = 2,
            alias = "terminal_fps:wall",
            name = "Wall",
            solid = true,
        },
    ) or_return
    return Game_Map_Tile_Registry_Error.No_Error
}
