// sRGB+HWB.swift
// HWB color model conversions for sRGB

public import IEC_61966_Shared

// MARK: - HWB to sRGB

extension IEC_61966.`2`.`1`.sRGB {
    /// Create sRGB from HWB components
    ///
    /// This is the canonical HWB → sRGB conversion using validated types.
    ///
    /// - Parameters:
    ///   - hue: Hue angle (auto-normalizes to 0-360°)
    ///   - whiteness: Whiteness component (0-1, validated)
    ///   - blackness: Blackness component (0-1, validated)
    ///
    /// ## Example
    ///
    /// ```swift
    /// let red = sRGB(
    ///     hue: Hue(0),
    ///     whiteness: try Whiteness(0),
    ///     blackness: try Blackness(0)
    /// )
    /// ```
    ///
    /// ## Color Model
    ///
    /// HWB is an alternative to HSL/HSV that's often more intuitive:
    /// - **Hue**: The color angle on the color wheel
    /// - **Whiteness**: How much white is mixed in (0 = pure color, 1 = white)
    /// - **Blackness**: How much black is mixed in (0 = pure color, 1 = black)
    ///
    /// Note: If whiteness + blackness >= 1, the result is a shade of gray.
    public init(
        hue: IEC_61966.`2`.`1`.Hue,
        whiteness: IEC_61966.`2`.`1`.Whiteness,
        blackness: IEC_61966.`2`.`1`.Blackness
    ) {
        var w = whiteness.value
        var b = blackness.value

        // Normalize if w + b >= 1
        let total = w + b
        if total >= 1 {
            w = w / total
            b = b / total
        }

        // Start with pure hue (HSL with s=1, l=0.5)
        let base = Self(
            hue: hue,
            saturation: IEC_61966.`2`.`1`.Saturation(clamping: 1),
            lightness: IEC_61966.`2`.`1`.Lightness(clamping: 0.5)
        )

        // Mix with white and black
        let scale = 1 - w - b
        self.r = base.r * scale + w
        self.g = base.g * scale + w
        self.b = base.b * scale + w
    }

    /// Convenience: Create sRGB from HWB with Double values
    ///
    /// - Parameters:
    ///   - hue: Hue in degrees (wraps automatically via normalizing)
    ///   - whiteness: Whiteness (clamped to 0-1)
    ///   - blackness: Blackness (clamped to 0-1)
    ///
    /// - Note: This is a convenience that wraps the typed initializer.
    ///   Use `init(hue:whiteness:blackness:)` for type-safe construction.
    public init(hue: Double, whiteness: Double, blackness: Double) {
        self.init(
            hue: IEC_61966.`2`.`1`.Hue(normalizing: hue),
            whiteness: IEC_61966.`2`.`1`.Whiteness(clamping: whiteness),
            blackness: IEC_61966.`2`.`1`.Blackness(clamping: blackness)
        )
    }
}

// MARK: - sRGB to HWB

extension IEC_61966.`2`.`1`.sRGB {
    /// HWB representation of this color
    ///
    /// Returns validated typed components:
    /// - `hue`: Hue angle (normalized)
    /// - `whiteness`: Whiteness component (0-1)
    /// - `blackness`: Blackness component (0-1)
    public var hwb: (
        hue: IEC_61966.`2`.`1`.Hue,
        whiteness: IEC_61966.`2`.`1`.Whiteness,
        blackness: IEC_61966.`2`.`1`.Blackness
    ) {
        let (h, w, b) = hwbValues
        return (
            hue: IEC_61966.`2`.`1`.Hue(normalizing: h),
            whiteness: IEC_61966.`2`.`1`.Whiteness(clamping: w),
            blackness: IEC_61966.`2`.`1`.Blackness(clamping: b)
        )
    }

    /// Convenience: HWB representation as raw Double values
    ///
    /// Returns a tuple of:
    /// - `h`: Hue in degrees (0-360)
    /// - `w`: Whiteness (0-1)
    /// - `b`: Blackness (0-1)
    ///
    /// - Note: Prefer the typed `hwb` property for type-safe access.
    public var hwbValues: (h: Double, w: Double, b: Double) {
        let hsl = self.hslValues
        let w = min(r, g, b)
        let b = 1 - max(r, g, b)
        return (h: hsl.h, w: w, b: b)
    }
}
