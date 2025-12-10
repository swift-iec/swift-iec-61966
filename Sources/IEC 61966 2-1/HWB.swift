// HWB.swift
// IEC 61966-2-1 — HWB Color Model
//
// HWB (Hue, Whiteness, Blackness) is an alternative cylindrical representation of sRGB.

public import IEC_61966_Shared

extension IEC_61966.`2`.`1` {
    /// HWB Color
    ///
    /// HWB represents colors using validated typed components:
    /// - `hue`: The color angle on the color wheel (auto-normalizes to 0-360°)
    /// - `whiteness`: How much white is mixed in (0-1, validated)
    /// - `blackness`: How much black is mixed in (0-1, validated)
    ///
    /// ## Color Model
    ///
    /// HWB is often more intuitive than HSL:
    /// - **Hue**: 0° = red, 120° = green, 240° = blue
    /// - **Whiteness**: 0 = pure color, 1 = white
    /// - **Blackness**: 0 = pure color, 1 = black
    ///
    /// Note: If whiteness + blackness >= 1, the result is a shade of gray.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let red = HWB(
    ///     hue: Hue(0),
    ///     whiteness: try Whiteness(0),
    ///     blackness: try Blackness(0)
    /// )
    /// ```
    ///
    /// ## Reference
    ///
    /// HWB is a cylindrical transformation of sRGB (IEC 61966-2-1).
    public struct HWB: Sendable, Hashable {
        /// Hue angle (auto-normalized to 0-360°)
        public let hue: Hue

        /// Whiteness component (0-1)
        public let whiteness: Whiteness

        /// Blackness component (0-1)
        public let blackness: Blackness

        /// Create an HWB color from validated components
        ///
        /// - Parameters:
        ///   - hue: Hue angle
        ///   - whiteness: Whiteness component
        ///   - blackness: Blackness component
        public init(
            hue: Hue,
            whiteness: Whiteness,
            blackness: Blackness
        ) {
            self.hue = hue
            self.whiteness = whiteness
            self.blackness = blackness
        }
    }
}

extension IEC_61966.`2`.`1`.HWB {
    /// Convenience: Create an HWB color from Double values
    ///
    /// - Parameters:
    ///   - h: Hue in degrees (wraps automatically via normalizing)
    ///   - w: Whiteness (clamped to 0-1)
    ///   - b: Blackness (clamped to 0-1)
    public init(h: Double, w: Double, b: Double) {
        self.hue = Hue(normalizing: h)
        self.whiteness = Whiteness(clamping: w)
        self.blackness = Blackness(clamping: b)
    }
}

// MARK: - HWB ↔ sRGB Conversions



extension IEC_61966.`2`.`1`.HWB {
    /// Create HWB from sRGB
    ///
    /// - Parameter srgb: An sRGB color
    public init(_ srgb: IEC_61966.`2`.`1`.sRGB) {
        let hwb = srgb.hwb
        self.hue = hwb.hue
        self.whiteness = hwb.whiteness
        self.blackness = hwb.blackness
    }

    /// Convert to sRGB
    public var srgb: IEC_61966.`2`.`1`.sRGB {
        IEC_61966.`2`.`1`.sRGB(
            hue: hue,
            whiteness: whiteness,
            blackness: blackness
        )
    }
}

// MARK: - HWB ↔ HSL Conversions

extension IEC_61966.`2`.`1`.HWB {
    /// Create HWB from HSL
    ///
    /// - Parameter hsl: An HSL color
    public init(_ hsl: IEC_61966.`2`.`1`.HSL) {
        self.init(hsl.srgb)
    }

    /// Convert to HSL
    public var hsl: IEC_61966.`2`.`1`.HSL {
        IEC_61966.`2`.`1`.HSL(srgb)
    }
}

// MARK: - Convenience Accessors

extension IEC_61966.`2`.`1`.HWB {
    /// Hue in degrees (0-360)
    public var h: Double { hue.degrees }

    /// Whiteness value (0-1)
    public var w: Double { whiteness.value }

    /// Blackness value (0-1)
    public var b: Double { blackness.value }
}

