#pragma once

#include <cstdint>

#include "graphics/color.hpp"

namespace terminal_fps::graphics {
    /**
     * A simple 2D image.
     */
    class Texture {
    private:
        /**
         * The width of the texture, in pixels.
         */
        uint16_t m_width;

        /**
         * The height of the texture, in pixels.
         */
        uint16_t m_height;

        /**
         * The pixels making up the texture.
         *
         * Arranged in row-major order.
         */
        Color* m_pixels;

        /**
         * The copy constructor.
         *
         * @param other The object to copy.
         */
        Texture(const Texture& other) = delete;

        /**
         * The copy assignment operator.
         *
         * @param other The object to copy.
         *
         * @returns A copy of the object.
         */
        Texture& operator=(const Texture& other) = delete;

    public:
        /**
         * Create a new texture with the given dimensions.
         *
         * @param width The width of the texture to create, in pixels.
         * @param height The height of the texture to create, in pixels.
         */
        Texture(uint16_t width, uint16_t height);

        /**
         * The finalizer.
         */
        ~Texture();

        /**
         * Get the width of the texture, in pixels.
         *
         * @returns The width of the texture, in pixels.
         */
        uint16_t GetWidth() const;

        /**
         * Get the height of the texture, in pixels.
         *
         * @returns The height of the texture, in pixels.
         */
        uint16_t GetHeight() const;

        /**
         * Get the number of pixels in the texture.
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
        Color* GetPixel(uint16_t x, uint16_t y) const;

        /**
         * Set the pixel at the given coordinates.
         *
         * @param x The x coordinate of the pixel to set.
         * @param y The y coordinate of the pixel to set.
         * @param value The value to set the pixel to.
         *
         * @throws std::out_of_range if the given coordinates are out of range.
         */
        void SetPixel(uint16_t x, uint16_t y, const Color& value);
    }; // class Texture
} // namespace terminal_fps::graphics
