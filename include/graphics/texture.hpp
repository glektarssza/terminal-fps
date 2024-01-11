/**
 * @file include/graphics/texture.hpp
 * @author G'lek Tarssza
 * @copyright Copyright (c) 2024 G'lek Tarssza
 * @copyright All rights reserved.
 */

#pragma once

//-- C Standard Library
#include <cstdint>
#include <cstdlib>

//-- Project Code
#include "graphics/color.hpp"
#include "graphics/pixel.hpp"

namespace terminal_fps::graphics {
    /**
     * A simple 2D image construct.
     */
    struct Texture {
        /**
         * The width of the texture, in pixels.
         */
        uint16_t width;

        /**
         * The height of the texture, in pixels.
         */
        uint16_t height;

        /**
         * The pixels in the texture.
         */
        Pixel* pixels;

        /**
         * Create a new instance.
         *
         * @param width The width of the new instance to create, in pixels.
         * @param height The height of the new instance to create, in pixels.
         */
        Texture(uint16_t width, uint16_t height);

        /**
         * Get the number of pixels in the instance.
         *
         * @returns The number of pixels in the instance.
         */
        size_t getPixelCount() const;

        /**
         * Get the pixel at the given coordinate in the instance.
         *
         * @param x The X coordinate of the pixel to get.
         * @param y The Y coordinate of the pixel to get.
         *
         * @returns A reference to the pixel at the given coordinates.
         */
        Pixel& getPixel(uint16_t x, uint16_t y) const;

        /**
         * Set the pixel at the given coordinate in the instance.
         *
         * @param x The X coordinate of the pixel to get.
         * @param y The Y coordinate of the pixel to get.
         * @param value The pixel value to assign to the given coordinate.
         */
        void setPixel(uint16_t x, uint16_t y, const Pixel& value);

        /**
         * Fill the instance with the given value.
         *
         * @param value The pixel value to fill the instance with.
         */
        void fill(const Pixel& value);

        /**
         * Clear the instance by filling it with the default pixel value.
         */
        void clear();
    };
} // namespace terminal_fps::graphics
