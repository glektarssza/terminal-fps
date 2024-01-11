/**
 * @file src/graphics/texture.cpp
 * @author G'lek Tarssza
 * @copyright Copyright (c) 2024 G'lek Tarssza
 * @copyright All rights reserved.
 */

//-- Project Code
#include "graphics/texture.hpp"

//-- Standard Library
#include <stdexcept>

namespace terminal_fps::graphics {
    Texture::Texture(uint16_t width, uint16_t height) {
        this->width = width;
        this->height = height;
        this->pixels =
            static_cast<Pixel*>(calloc(width * height, sizeof(Pixel)));
        if (this->pixels == nullptr) {
            throw std::runtime_error(
                "Failed to allocate space for texture pixels");
        }
    }

    size_t Texture::getPixelCount() const {
        return this->width * this->height;
    }

    Pixel& Texture::getPixel(uint16_t x, uint16_t y) const {
        if (x >= this->width || y >= this->height) {
            throw std::range_error("Coordinate outside texture range");
        }
        return this->pixels[y * this->height + x];
    }

    void Texture::setPixel(uint16_t x, uint16_t y, const Pixel& value) {
        if (x >= this->width || y >= this->height) {
            throw std::range_error("Coordinate outside texture range");
        }
        this->pixels[y * this->height + x] = value;
    }

    void Texture::fill(const Pixel& value) {
        auto pixelCount = this->getPixelCount();
        for (auto i = 0; i < pixelCount; i++) {
            this->pixels[i] = value;
        }
    }

    void Texture::clear() {
        this->fill(Pixel::getDefault());
    }
} // namespace terminal_fps::graphics
