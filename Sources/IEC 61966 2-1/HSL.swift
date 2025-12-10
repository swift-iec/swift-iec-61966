// HSL.swift
// IEC 61966-2-1 — HSL Color Model
//
// HSL (Hue, Saturation, Lightness) is a cylindrical representation of sRGB.

public import IEC_61966_Shared

extension IEC_61966.`2`.`1` {
    /// HSL Color
    ///
    /// HSL represents colors using validated typed components:
    /// - `hue`: The color angle on the color wheel (auto-normalizes to 0-360°)
    /// - `saturation`: The intensity of the color (0-1, validated)
    /// - `lightness`: The brightness (0-1, validated)
    ///
    /// ## Color Model
    ///
    /// - **Hue**: 0° = red, 120° = green, 240° = blue
    /// - **Saturation**: 0 = gray, 1 = full color
    /// - **Lightness**: 0 = black, 0.5 = pure color, 1 = white
    ///
    /// ## Example
    ///
    /// ```swift
    /// let red = HSL(
    ///     hue: Hue(0),
    ///     saturation: try Saturation(1),
    ///     lightness: try Lightness(0.5)
    /// )
    /// ```
    ///
    /// ## Reference
    ///
    /// HSL is a cylindrical transformation of sRGB (IEC 61966-2-1).
    public struct HSL: Sendable, Hashable {
        /// Hue angle (auto-normalized to 0-360°)
        public let hue: Hue
        
        /// Saturation component (0-1)
        public let saturation: Saturation
        
        /// Lightness component (0-1)
        public let lightness: Lightness
        
        /// Create an HSL color from validated components
        ///
        /// - Parameters:
        ///   - hue: Hue angle
        ///   - saturation: Saturation component
        ///   - lightness: Lightness component
        public init(
            hue: Hue,
            saturation: Saturation,
            lightness: Lightness
        ) {
            self.hue = hue
            self.saturation = saturation
            self.lightness = lightness
        }
    }
}

extension IEC_61966.`2`.`1`.HSL {
    /// Convenience: Create an HSL color from Double values
    ///
    /// - Parameters:
    ///   - h: Hue in degrees (wraps automatically via normalizing)
    ///   - s: Saturation (clamped to 0-1)
    ///   - l: Lightness (clamped to 0-1)
    public init(h: Double, s: Double, l: Double) {
        self.hue = Hue(normalizing: h)
        self.saturation = Saturation(clamping: s)
        self.lightness = Lightness(clamping: l)
    }
}

// MARK: - HSL ↔ sRGB Conversions

extension IEC_61966.`2`.`1`.HSL {
    /// Create HSL from sRGB
    ///
    /// - Parameter srgb: An sRGB color
    public init(_ srgb: IEC_61966.`2`.`1`.sRGB) {
        let hsl = srgb.hsl
        self.hue = hsl.hue
        self.saturation = hsl.saturation
        self.lightness = hsl.lightness
    }

    /// Convert to sRGB
    public var srgb: IEC_61966.`2`.`1`.sRGB {
        IEC_61966.`2`.`1`.sRGB(
            hue: hue,
            saturation: saturation,
            lightness: lightness
        )
    }
}

// MARK: - Convenience Accessors

extension IEC_61966.`2`.`1`.HSL {
    /// Hue in degrees (0-360)
    public var h: Double { hue.degrees }

    /// Saturation value (0-1)
    public var s: Double { saturation.value }

    /// Lightness value (0-1)
    public var l: Double { lightness.value }
}

