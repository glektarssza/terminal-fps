#pragma once

#include <cstdint>

#include "graphics/pixel.hpp"
#include "graphics/texture.hpp"

namespace terminal_fps::graphics {
    class Framebuffer {
    private:
        /**
         * The width of the framebuffer, in pixels.
         */
        uint16_t m_width;

        /**
         * The height of the framebuffer, in pixels.
         */
        uint16_t m_height;

        /**
         * The pixels making up the framebuffer.
         *
         * Arranged in row-major order.
         */
        Pixel* m_pixels;

        /**
         * The copy constructor.
         *
         * @param other The object to copy.
         */
        Framebuffer(const Framebuffer& other) = delete;

        /**
         * The copy assignment operator.
         *
         * @param other The object to copy.
         *
         * @returns A copy of the object.
         */
        Framebuffer& operator=(const Framebuffer& other) = delete;

    public:
        /**
         * Create a new framebuffer with the given dimensions.
         *
         * @param width The width of the framebuffer to create, in pixels.
         * @param height The height of the framebuffer to create, in pixels.
         */
        Framebuffer(uint16_t width, uint16_t height);

        /**
         * The finalizer.
         */
        ~Framebuffer();

        /**
         * Get the width of the framebuffer, in pixels.
         *
         * @returns The width of the framebuffer, in pixels.
         */
        uint16_t GetWidth() const;

        /**
         * Get the height of the framebuffer, in pixels.
         *
         * @returns The height of the framebuffer, in pixels.
         */
        uint16_t GetHeight() const;

        /**
         * Get the number of pixels in the framebuffer.
         *
         * @returns The number of pixels in the framebuffer.
         */
        uint32_t GetPixelCount() const;

        /**
         * Get the pixel at the given coordinates.
         *
         * @param x The x coordinate of the pixel to get.
         * @param y The y coordinate of the pixel to get.
         *
         * @returns The pixel at the given coordinates.
         *
         * @throws std::out_of_range if the given coordinates are out of range.
         */
        Pixel* GetPixel(uint16_t x, uint16_t y) const;

        /**
         * Set the pixel at the given coordinates.
         *
         * @param x The x coordinate of the pixel to set.
         * @param y The y coordinate of the pixel to set.
         * @param value The value to set the pixel to.
         *
         * @throws std::out_of_range if the given coordinates are out of range.
         */
        void SetPixel(uint16_t x, uint16_t y, const Pixel& value);
    }; // class Framebuffer
} // namespace terminal_fps::graphics
