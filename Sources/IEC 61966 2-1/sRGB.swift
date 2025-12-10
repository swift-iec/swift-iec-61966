// sRGB.swift
// IEC 61966-2-1:1999 — sRGB Color Type

public import IEC_61966_Shared

// MARK: - sRGB Color

extension IEC_61966.`2`.`1` {
    /// sRGB Color
    ///
    /// The sRGB color space as defined by IEC 61966-2-1:1999.
    ///
    /// Components are normalized to the range [0, 1]:
    /// - `red`: Red component (0 = no red, 1 = full red)
    /// - `green`: Green component (0 = no green, 1 = full green)
    /// - `blue`: Blue component (0 = no blue, 1 = full blue)
    ///
    /// ## Colorimetry
    ///
    /// Per IEC 61966-2-1, sRGB uses:
    /// - **White point**: D65 (x = 0.3127, y = 0.3290)
    /// - **Primaries**:
    ///   - Red: x = 0.64, y = 0.33
    ///   - Green: x = 0.30, y = 0.60
    ///   - Blue: x = 0.15, y = 0.06
    /// - **Transfer function**: ~2.2 gamma with linear segment near black
    ///
    /// ## Example
    ///
    /// ```swift
    /// let red = sRGB(
    ///     red: try Red(1),
    ///     green: try Green(0),
    ///     blue: try Blue(0)
    /// )
    /// ```
    ///
    /// ## Reference
    ///
    /// IEC 61966-2-1:1999, Section 4 — Colorimetry
    public struct sRGB: Sendable, Hashable {
        /// Red component (0-1)
        public var r: Double

        /// Green component (0-1)
        public var g: Double

        /// Blue component (0-1)
        public var b: Double

        /// Create an sRGB color from typed components
        ///
        /// - Parameters:
        ///   - red: Red component
        ///   - green: Green component
        ///   - blue: Blue component
        public init(red: Red, green: Green, blue: Blue) {
            self.r = red.value
            self.g = green.value
            self.b = blue.value
        }

        /// Convenience: Create an sRGB color from Double values
        ///
        /// - Parameters:
        ///   - r: Red component (clamped to 0-1)
        ///   - g: Green component (clamped to 0-1)
        ///   - b: Blue component (clamped to 0-1)
        public init(r: Double, g: Double, b: Double) {
            self.r = min(max(r, 0), 1)
            self.g = min(max(g, 0), 1)
            self.b = min(max(b, 0), 1)
        }
    }
}

// MARK: - sRGB Channel Types

extension IEC_61966.`2`.`1` {
    /// Red channel component for sRGB color space
    ///
    /// Value is normalized to the range [0, 1]:
    /// - 0 = no red
    /// - 1 = full red
    ///
    /// ## Example
    ///
    /// ```swift
    /// let full = try sRGB.Red(1)
    /// let half = try sRGB.Red(0.5)
    /// ```
    public struct Red: Sendable, Hashable {
        /// The red channel value [0, 1]
        public let value: Double

        /// Creates a red channel value
        ///
        /// - Parameter value: Red channel in range [0, 1]
        /// - Throws: `Red.Error` if value is outside valid range
        public init(_ value: Double) throws(Error) {
            guard value >= 0 && value <= 1 else {
                throw Error(value: value)
            }
            self.value = value
        }
    }
}

extension IEC_61966.`2`.`1`.Red {
    /// Error thrown when a red channel value is out of valid range [0, 1]
    public struct Error: Swift.Error, Sendable, CustomStringConvertible {
        public let value: Double
        public static let validRange: ClosedRange<Double> = 0...1

        public var description: String {
            "Red channel value \(value) is out of valid range \(Self.validRange)"
        }
    }
}

extension IEC_61966.`2`.`1`.Red {
    /// Creates a red channel by clamping any value to [0, 1]
    ///
    /// - Parameter value: The red channel value (any value, will be clamped)
    public init(clamping value: Double) {
        self.value = min(max(value, 0), 1)
    }
}

extension IEC_61966.`2`.`1` {
    /// Green channel component for sRGB color space
    ///
    /// Value is normalized to the range [0, 1]:
    /// - 0 = no green
    /// - 1 = full green
    ///
    /// ## Example
    ///
    /// ```swift
    /// let full = try sRGB.Green(1)
    /// let half = try sRGB.Green(0.5)
    /// ```
    public struct Green: Sendable, Hashable {
        /// The green channel value [0, 1]
        public let value: Double

        /// Creates a green channel value
        ///
        /// - Parameter value: Green channel in range [0, 1]
        /// - Throws: `Green.Error` if value is outside valid range
        public init(_ value: Double) throws(Error) {
            guard value >= 0 && value <= 1 else {
                throw Error(value: value)
            }
            self.value = value
        }
    }
}

extension IEC_61966.`2`.`1`.Green {
    /// Error thrown when a green channel value is out of valid range [0, 1]
    public struct Error: Swift.Error, Sendable, CustomStringConvertible {
        public let value: Double
        public static let validRange: ClosedRange<Double> = 0...1

        public var description: String {
            "Green channel value \(value) is out of valid range \(Self.validRange)"
        }
    }
}

extension IEC_61966.`2`.`1`.Green {
    /// Creates a green channel by clamping any value to [0, 1]
    ///
    /// - Parameter value: The green channel value (any value, will be clamped)
    public init(clamping value: Double) {
        self.value = min(max(value, 0), 1)
    }
}

extension IEC_61966.`2`.`1` {
    /// Blue channel component for sRGB color space
    ///
    /// Value is normalized to the range [0, 1]:
    /// - 0 = no blue
    /// - 1 = full blue
    ///
    /// ## Example
    ///
    /// ```swift
    /// let full = try sRGB.Blue(1)
    /// let half = try sRGB.Blue(0.5)
    /// ```
    public struct Blue: Sendable, Hashable {
        /// The blue channel value [0, 1]
        public let value: Double

        /// Creates a blue channel value
        ///
        /// - Parameter value: Blue channel in range [0, 1]
        /// - Throws: `Blue.Error` if value is outside valid range
        public init(_ value: Double) throws(Error) {
            guard value >= 0 && value <= 1 else {
                throw Error(value: value)
            }
            self.value = value
        }
    }
}

extension IEC_61966.`2`.`1`.Blue {
    /// Error thrown when a blue channel value is out of valid range [0, 1]
    public struct Error: Swift.Error, Sendable, CustomStringConvertible {
        public let value: Double
        public static let validRange: ClosedRange<Double> = 0...1

        public var description: String {
            "Blue channel value \(value) is out of valid range \(Self.validRange)"
        }
    }
}

extension IEC_61966.`2`.`1`.Blue {
    /// Creates a blue channel by clamping any value to [0, 1]
    ///
    /// - Parameter value: The blue channel value (any value, will be clamped)
    public init(clamping value: Double) {
        self.value = min(max(value, 0), 1)
    }
}

extension IEC_61966.`2`.`1`.sRGB {
    /// Create a grayscale sRGB color
    ///
    /// - Parameter gray: Gray value (0 = black, 1 = white)
    public init(gray: Double) {
        self.r = gray
        self.g = gray
        self.b = gray
    }
}

// MARK: - Common Colors
extension IEC_61966.`2`.`1`.sRGB {
    /// Black (0, 0, 0)
    public static let black = Self(r: 0, g: 0, b: 0)

    /// White (1, 1, 1)
    public static let white = Self(r: 1, g: 1, b: 1)

    /// Red (1, 0, 0)
    public static let red = Self(r: 1, g: 0, b: 0)

    /// Green (0, 1, 0)
    public static let green = Self(r: 0, g: 1, b: 0)

    /// Blue (0, 0, 1)
    public static let blue = Self(r: 0, g: 0, b: 1)

    /// Cyan (0, 1, 1)
    public static let cyan = Self(r: 0, g: 1, b: 1)

    /// Magenta (1, 0, 1)
    public static let magenta = Self(r: 1, g: 0, b: 1)

    /// Yellow (1, 1, 0)
    public static let yellow = Self(r: 1, g: 1, b: 0)
}

// MARK: - 8-bit Integer Components

extension IEC_61966.`2`.`1`.sRGB {
    /// Create sRGB from 8-bit integer components (0-255)
    ///
    /// - Parameters:
    ///   - r: Red component (0-255)
    ///   - g: Green component (0-255)
    ///   - b: Blue component (0-255)
    public init(r255 r: Int, g255 g: Int, b255 b: Int) {
        self.r = Double(r) / 255.0
        self.g = Double(g) / 255.0
        self.b = Double(b) / 255.0
    }

    /// Red component as 8-bit integer (0-255)
    public var r255: Int {
        Int((r * 255).rounded().clamped(to: 0...255))
    }

    /// Green component as 8-bit integer (0-255)
    public var g255: Int {
        Int((g * 255).rounded().clamped(to: 0...255))
    }

    /// Blue component as 8-bit integer (0-255)
    public var b255: Int {
        Int((b * 255).rounded().clamped(to: 0...255))
    }
}

// MARK: - Hex String

extension IEC_61966.`2`.`1`.sRGB {
    /// Create sRGB from hex string
    ///
    /// Supports formats: `#RGB`, `#RRGGBB`, `RGB`, `RRGGBB`
    ///
    /// - Parameter hex: Hex color string
    public init?(hex: String) {
        var hexString = hex
        // Trim whitespace manually (no Foundation)
        while hexString.first?.isWhitespace == true {
            hexString.removeFirst()
        }
        while hexString.last?.isWhitespace == true {
            hexString.removeLast()
        }
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }

        // Parse hex without Foundation Scanner
        guard let value = UInt64(hexString, radix: 16) else {
            return nil
        }

        switch hexString.count {
        case 3: // RGB
            let r = Double((value >> 8) & 0xF) / 15.0
            let g = Double((value >> 4) & 0xF) / 15.0
            let b = Double(value & 0xF) / 15.0
            self.init(r: r, g: g, b: b)

        case 6: // RRGGBB
            let r = Double((value >> 16) & 0xFF) / 255.0
            let g = Double((value >> 8) & 0xFF) / 255.0
            let b = Double(value & 0xFF) / 255.0
            self.init(r: r, g: g, b: b)

        default:
            return nil
        }
    }

    /// Hex string representation (#RRGGBB)
    public var hex: String {
        // Build hex string without Foundation String(format:)
        let hexChars: [Character] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"]
        let r = r255
        let g = g255
        let b = b255
        return "#" +
            String(hexChars[(r >> 4) & 0xF]) + String(hexChars[r & 0xF]) +
            String(hexChars[(g >> 4) & 0xF]) + String(hexChars[g & 0xF]) +
            String(hexChars[(b >> 4) & 0xF]) + String(hexChars[b & 0xF])
    }
}

// MARK: - Clamping Helper

extension Double {
    func clamped(to range: ClosedRange<Double>) -> Double {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
