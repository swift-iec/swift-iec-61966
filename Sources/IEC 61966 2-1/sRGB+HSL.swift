// sRGB+HSL.swift
// HSL color model conversions for sRGB

public import IEC_61966_Shared

// MARK: - HSL to sRGB

extension IEC_61966.`2`.`1`.sRGB {
    /// Create sRGB from HSL components
    ///
    /// This is the canonical HSL → sRGB conversion using validated types.
    ///
    /// - Parameters:
    ///   - hue: Hue angle (auto-normalizes to 0-360°)
    ///   - saturation: Saturation component (0-1, validated)
    ///   - lightness: Lightness component (0-1, validated)
    ///
    /// ## Example
    ///
    /// ```swift
    /// let red = sRGB(
    ///     hue: Hue(0),
    ///     saturation: try Saturation(1),
    ///     lightness: try Lightness(0.5)
    /// )
    /// ```
    ///
    /// ## Color Model
    ///
    /// HSL represents colors as:
    /// - **Hue**: The color angle on the color wheel (0° = red, 120° = green, 240° = blue)
    /// - **Saturation**: The intensity of the color (0 = gray, 1 = full color)
    /// - **Lightness**: The brightness (0 = black, 0.5 = pure color, 1 = white)
    public init(
        hue: IEC_61966.`2`.`1`.Hue,
        saturation: IEC_61966.`2`.`1`.Saturation,
        lightness: IEC_61966.`2`.`1`.Lightness
    ) {
        let h = hue.degrees
        let s = saturation.value
        let l = lightness.value

        if s == 0 {
            // Achromatic (gray)
            self.init(gray: l)
            return
        }

        let q = l < 0.5 ? l * (1 + s) : l + s - l * s
        let p = 2 * l - q

        let hNormalized = h / 360.0

        let r = Self.hueToRgb(p: p, q: q, t: hNormalized + 1.0/3.0)
        let g = Self.hueToRgb(p: p, q: q, t: hNormalized)
        let b = Self.hueToRgb(p: p, q: q, t: hNormalized - 1.0/3.0)
        self.init(r: r, g: g, b: b)
    }

    /// Convenience: Create sRGB from HSL with Double values
    ///
    /// - Parameters:
    ///   - h: Hue in degrees (wraps automatically via normalizing)
    ///   - s: Saturation (clamped to 0-1)
    ///   - l: Lightness (clamped to 0-1)
    ///
    /// - Note: This is a convenience that wraps the typed initializer.
    ///   Use `init(hue:saturation:lightness:)` for type-safe construction.
    public init(h: Double, s: Double, l: Double) {
        self.init(
            hue: IEC_61966.`2`.`1`.Hue(normalizing: h),
            saturation: IEC_61966.`2`.`1`.Saturation(clamping: s),
            lightness: IEC_61966.`2`.`1`.Lightness(clamping: l)
        )
    }

    private static func hueToRgb(p: Double, q: Double, t: Double) -> Double {
        var t = t
        if t < 0 { t += 1 }
        if t > 1 { t -= 1 }

        if t < 1.0/6.0 {
            return p + (q - p) * 6.0 * t
        }
        if t < 1.0/2.0 {
            return q
        }
        if t < 2.0/3.0 {
            return p + (q - p) * (2.0/3.0 - t) * 6.0
        }
        return p
    }
}

// MARK: - sRGB to HSL

extension IEC_61966.`2`.`1`.sRGB {
    /// HSL representation of this color
    ///
    /// Returns validated typed components:
    /// - `hue`: Hue angle (normalized)
    /// - `saturation`: Saturation component (0-1)
    /// - `lightness`: Lightness component (0-1)
    public var hsl: (
        hue: IEC_61966.`2`.`1`.Hue,
        saturation: IEC_61966.`2`.`1`.Saturation,
        lightness: IEC_61966.`2`.`1`.Lightness
    ) {
        let (h, s, l) = hslValues
        return (
            hue: IEC_61966.`2`.`1`.Hue(normalizing: h),
            saturation: IEC_61966.`2`.`1`.Saturation(clamping: s),
            lightness: IEC_61966.`2`.`1`.Lightness(clamping: l)
        )
    }

    /// Convenience: HSL representation as raw Double values
    ///
    /// Returns a tuple of:
    /// - `h`: Hue in degrees (0-360)
    /// - `s`: Saturation (0-1)
    /// - `l`: Lightness (0-1)
    ///
    /// - Note: Prefer the typed `hsl` property for type-safe access.
    public var hslValues: (h: Double, s: Double, l: Double) {
        let maxC = max(r, g, b)
        let minC = min(r, g, b)
        let delta = maxC - minC

        // Lightness
        let l = (maxC + minC) / 2.0

        // Achromatic
        if delta == 0 {
            return (h: 0, s: 0, l: l)
        }

        // Saturation
        let s = l > 0.5
            ? delta / (2.0 - maxC - minC)
            : delta / (maxC + minC)

        // Hue
        var h: Double
        switch maxC {
        case r:
            h = ((g - b) / delta).truncatingRemainder(dividingBy: 6)
        case g:
            h = (b - r) / delta + 2
        default: // b
            h = (r - g) / delta + 4
        }

        h *= 60
        if h < 0 { h += 360 }

        return (h: h, s: s, l: l)
    }
}
