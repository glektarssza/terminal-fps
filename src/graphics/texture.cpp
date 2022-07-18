#include "graphics/texture.hpp"

#include <stdexcept>

namespace terminal_fps::graphics {
    Texture::Texture(uint16_t width, uint16_t height) {
        m_width = width;
        m_height = height;
        if (m_width * m_height == 0) {
            m_pixels = nullptr;
        } else {
            m_pixels =
                static_cast<Color*>(calloc(m_width * m_height, sizeof(Color)));
            if (m_pixels == nullptr) {
                throw std::runtime_error("Failed to allocate memory");
            }
            for (uint32_t i = 0; i < m_width * m_height; ++i) {
                m_pixels[i] = Color::getDefault();
            }
        }
    }

    Texture::~Texture() {
        if (m_pixels != nullptr) {
            free(m_pixels);
            m_pixels = nullptr;
        }
    }

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
