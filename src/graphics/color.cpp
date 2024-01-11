/**
 * @file src/graphics/color.cpp
 * @author G'lek Tarssza
 * @copyright Copyright (c) 2024 G'lek Tarssza
 * @copyright All rights reserved.
 */

//-- Project Code
#include "graphics/color.hpp"

//-- Standard Library
#include <sstream>

namespace terminal_fps::graphics {
    Color Color::getDefault() {
        return {0, 0, 0};
    }

    std::string Color::toANSIBackground() {
        auto ostream = std::ostringstream();
        ostream << "\x1B[48;2;" << this->red << ";" << this->green << ";"
                << this->blue << "m";
        return ostream.str();
    }

    std::string Color::toANSIForeground() {
        auto ostream = std::ostringstream();
        ostream << "\x1B[38;2;" << this->red << ";" << this->green << ";"
                << this->blue << "m";
        return ostream.str();
    }
} // namespace terminal_fps::graphics
