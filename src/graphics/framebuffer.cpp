#include "graphics/framebuffer.hpp"

#include <stdexcept>

namespace terminal_fps::graphics {
    Framebuffer::Framebuffer(uint16_t width, uint16_t height) {
        m_width = width;
        m_height = height;
        if (m_width * m_height == 0) {
            m_pixels = nullptr;
        } else {
            m_pixels =
                static_cast<Pixel*>(calloc(m_width * m_height, sizeof(Pixel)));
            if (m_pixels == nullptr) {
                throw std::runtime_error("Failed to allocate memory");
            }
            for (uint32_t i = 0; i < m_width * m_height; ++i) {
                m_pixels[i] = Pixel::getDefault();
            }
        }
    }

    Framebuffer::~Framebuffer() {
        if (m_pixels != nullptr) {
            free(m_pixels);
            m_pixels = nullptr;
        }
    }

    uint16_t Framebuffer::GetWidth() const {
        return m_width;
    }

    uint16_t Framebuffer::GetHeight() const {
        return m_height;
    }

    uint32_t Framebuffer::GetPixelCount() const {
        return m_width * m_height;
    }

    Pixel* Framebuffer::GetPixel(uint16_t x, uint16_t y) const {
        if (x >= m_width || y >= m_height) {
            throw std::out_of_range("Coordinates out of range");
        }
        return &m_pixels[y * m_width + x];
    }

    void Framebuffer::SetPixel(uint16_t x, uint16_t y, const Pixel& value) {
        if (x >= m_width || y >= m_height) {
            throw std::out_of_range("Coordinates out of range");
        }
        m_pixels[y * m_width + x] = value;
    }
} // namespace terminal_fps::graphics
