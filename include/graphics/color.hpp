/**
 * @file include/graphics/color.hpp
 * @author G'lek Tarssza
 * @copyright Copyright (c) 2024 G'lek Tarssza
 * @copyright All rights reserved.
 */

#pragma once

//-- C Standard Library
#include <cstdint>

namespace terminal_fps::graphics {
    /**
     * A simple three-component color.
     */
    struct Color {
        /**
         * Get the default value.
         *
         * @returns The default value.
         */
        static Color getDefault();

        /**
         * The red component.
         */
        uint8_t red;

        /**
         * The green component.
         */
        uint8_t green;

        /**
         * The blue component.
         */
        uint8_t blue;
    };
} // namespace terminal_fps::graphics
