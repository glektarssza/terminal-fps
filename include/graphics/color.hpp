#pragma once

#include <cstdint>

namespace terminal_fps::graphics {
    /**
     * A simple RGB color.
     */
    struct Color {
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
    }; // struct Color
} // namespace terminal_fps::graphics
