/**
 * @file src/graphics/pixel.cpp
 * @author G'lek Tarssza
 * @copyright Copyright (c) 2024 G'lek Tarssza
 * @copyright All rights reserved.
 */

//-- Project Code
#include "graphics/pixel.hpp"

//-- Standard Library
#include <codecvt>
#include <sstream>

namespace terminal_fps::graphics {
    Pixel Pixel::getDefault() {
        return {Color::getDefaultForeground(), Color::getDefaultBackground(),
                u'\u2588'};
    }

    std::string Pixel::toANSISequence() const {
        auto conv =
            std::wstring_convert<std::codecvt_utf8_utf16<char16_t>, char16_t>{};
        auto ostream = std::ostringstream();
        ostream << this->backgroundColor.toANSIBackground()
                << this->foregroundColor.toANSIForeground()
                << conv.to_bytes(this->symbol);
        return ostream.str();
    }
} // namespace terminal_fps::graphics
