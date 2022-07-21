//! A module dealing with various graphics related APIs.

/// A basic RGB color.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Color {
    /// The red component.
    pub r: u8,

    /// The green component.
    pub g: u8,

    /// The blue component.
    pub b: u8,
}

impl Default for Color {
    fn default() -> Self {
        Color { r: 0, g: 0, b: 0 }
    }
}

impl Color {
    /// Create a new color from the given component values.
    pub fn new(r: u8, g: u8, b: u8) -> Self {
        Color { r, g, b }
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Pixel {
    /// The pixel color.
    pub color: Color,

    /// The symbol that represents the pixel.
    pub symbol: char,
}

impl Default for Pixel {
    fn default() -> Self {
        Pixel {
            color: Color::default(),
            symbol: '\u{2588}',
        }
    }
}

impl Pixel {
    /// Create a new pixel from the given color and symbol.
    pub fn new(color: Color, symbol: char) -> Self {
        Pixel { color, symbol }
    }
}

/// A simple structure representing a 2D grid of pixels.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Texture {
    /// The width of the texture, in pixels.
    _width: usize,

    /// The height of the texture, in pixels.
    _height: usize,

    /// The pixels of the texture.
    _pixels: Vec<Pixel>,
}

impl Texture {
    /// Create a new texture with the given dimensions.
    pub fn new(width: usize, height: usize) -> Self {
        Texture {
            _width: width,
            _height: height,
            _pixels: vec![Pixel::default(); width * height],
        }
    }
}
