/**
 * @file src/graphics/pixel.cpp
 * @author G'lek Tarssza
 * @copyright Copyright (c) 2024 G'lek Tarssza
 * @copyright All rights reserved.
 */

//-- Project Code
#include "graphics/pixel.hpp"

namespace terminal_fps::graphics {
    Pixel Pixel::getDefault() {
        return {Color::getDefaultForeground(), Color::getDefaultBackground(),
                u'\u2588'};
    }
} // namespace terminal_fps::graphics
