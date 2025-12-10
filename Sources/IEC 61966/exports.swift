// exports.swift
// IEC 61966 — Multimedia systems and equipment — Colour measurement and management

@_exported public import IEC_61966_Shared
@_exported public import IEC_61966_2_1

// MARK: - Color Types

extension IEC_61966 {
    /// sRGB color space (IEC 61966-2-1:1999)
    ///
    /// ```swift
    /// let red = IEC_61966.sRGB(r: 1, g: 0, b: 0)
    /// ```
    public typealias sRGB = IEC_61966.`2`.`1`.sRGB
}

extension IEC_61966 {
    /// Red channel component for sRGB (0-1, throws if out of range)
    public typealias Red = IEC_61966.`2`.`1`.Red
}

extension IEC_61966 {
    /// Green channel component for sRGB (0-1, throws if out of range)
    public typealias Green = IEC_61966.`2`.`1`.Green
}

extension IEC_61966 {
    /// Blue channel component for sRGB (0-1, throws if out of range)
    public typealias Blue = IEC_61966.`2`.`1`.Blue
}

extension IEC_61966 {
    /// Linear light value (scene-referred, before gamma encoding)
    public typealias LinearLight = IEC_61966.`2`.`1`.LinearLight
}

extension IEC_61966 {
    /// Linear sRGB color (scene-referred, before gamma encoding)
    public typealias LinearSRGB = IEC_61966.`2`.`1`.LinearSRGB
}

extension IEC_61966 {
    /// HSL color model (Hue, Saturation, Lightness)
    ///
    /// A cylindrical representation of sRGB.
    ///
    /// ```swift
    /// let red = IEC_61966.HSL(h: 0, s: 1, l: 0.5)
    /// ```
    public typealias HSL = IEC_61966.`2`.`1`.HSL
}

extension IEC_61966 {
    /// HWB color model (Hue, Whiteness, Blackness)
    ///
    /// An alternative cylindrical representation of sRGB.
    ///
    /// ```swift
    /// let red = IEC_61966.HWB(h: 0, w: 0, b: 0)
    /// ```
    public typealias HWB = IEC_61966.`2`.`1`.HWB
}

// MARK: - Color Component Types

extension IEC_61966 {
    /// Hue angle for color functions (automatically normalizes to 0-360°)
    public typealias Hue = IEC_61966.`2`.`1`.Hue
}

extension IEC_61966 {
    /// Saturation component for HSL (0-1, throws if out of range)
    public typealias Saturation = IEC_61966.`2`.`1`.Saturation
}

extension IEC_61966 {
    /// Lightness component for HSL (0-1, throws if out of range)
    public typealias Lightness = IEC_61966.`2`.`1`.Lightness
}

extension IEC_61966 {
    /// Whiteness component for HWB (0-1, throws if out of range)
    public typealias Whiteness = IEC_61966.`2`.`1`.Whiteness
}

extension IEC_61966 {
    /// Blackness component for HWB (0-1, throws if out of range)
    public typealias Blackness = IEC_61966.`2`.`1`.Blackness
}
