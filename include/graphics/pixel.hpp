/**
 * @file include/graphics/pixel.hpp
 * @author G'lek Tarssza
 * @copyright Copyright (c) 2024 G'lek Tarssza
 * @copyright All rights reserved.
 */

#pragma once

//-- Project Code
#include "graphics/color.hpp"

namespace terminal_fps::graphics {
    /**
     * A simple representation of a pixel in an output device.
     */
    struct Pixel {
        /**
         * Get the default value.
         *
         * @returns The default value.
         */
        static Pixel getDefault();

        /**
         * The color of the pixel.
         */
        Color foregroundColor;

        /**
         * The background color of the pixel.
         */
        Color backgroundColor;

        /**
         * The symbol that represents the pixel.
         */
        char16_t symbol;
    };
} // namespace terminal_fps::graphics
