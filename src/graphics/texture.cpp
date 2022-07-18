#include "graphics/texture.hpp"

#include <stdexcept>

namespace terminal_fps::graphics {
    uint16_t Texture::GetWidth() const {
        return m_width;
    }

    uint16_t Texture::GetHeight() const {
        return m_height;
    }

    uint32_t Texture::GetPixelCount() const {
        return m_width * m_height;
    }

    Color* Texture::GetPixel(uint16_t x, uint16_t y) const {
        if (x >= m_width || y >= m_height) {
            throw std::out_of_range("Coordinates out of range");
        }
        return &m_pixels[y * m_width + x];
    }

    void Texture::SetPixel(uint16_t x, uint16_t y, const Color& value) {
        if (x >= m_width || y >= m_height) {
            throw std::out_of_range("Coordinates out of range");
        }
        m_pixels[y * m_width + x] = value;
    }
} // namespace terminal_fps::graphics
