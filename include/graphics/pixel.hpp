/**
 * @file include/graphics/pixel.hpp
 * @author G'lek Tarssza
 * @copyright Copyright (c) 2024 G'lek Tarssza
 * @copyright All rights reserved.
 */

#pragma once

//-- Standard Library
#include <string>

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

        /**
         * Convert this instance to an ANSI control sequence for outputting the
         * instance.
         *
         * @returns An ANSI control sequence for outputting the instance.
         */
        std::string toANSISequence() const;
    };
} // namespace terminal_fps::graphics
