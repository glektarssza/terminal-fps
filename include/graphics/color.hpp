/**
 * @file include/graphics/color.hpp
 * @author G'lek Tarssza
 * @copyright Copyright (c) 2024 G'lek Tarssza
 * @copyright All rights reserved.
 */

#pragma once

//-- C Standard Library
#include <cstdint>

//-- Standard Library
#include <string>

namespace terminal_fps::graphics {
    /**
     * A simple three-component color.
     */
    struct Color {
        /**
         * Get the default background value.
         *
         * @returns The default value.
         */
        static Color getDefaultBackground();

        /**
         * Get the default foreground value.
         *
         * @returns The default value.
         */
        static Color getDefaultForeground();

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

        /**
         * Convert this instance to an ANSI control sequence for setting the
         * background color.
         *
         * @returns An ANSI control sequence for setting the background color.
         */
        std::string toANSIBackground();

        /**
         * Convert this instance to an ANSI control sequence for setting the
         * foreground color.
         *
         * @returns An ANSI control sequence for setting the foreground color.
         */
        std::string toANSIForeground();
    };
} // namespace terminal_fps::graphics
