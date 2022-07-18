#pragma once

#include "graphics/color.hpp"

namespace terminal_fps::graphics {
    /**
     * A simple representation of a pixel in the output device.
     */
    struct Pixel {
        static Pixel getDefault();

        /**
         * The color of the pixel.
         */
        Color color;

        /**
         * The symbol that represents the pixel.
         */
        char symbol;
    }; // struct Pixel
} // namespace terminal_fps::graphics
