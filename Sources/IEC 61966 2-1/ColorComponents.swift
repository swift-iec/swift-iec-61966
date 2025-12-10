// ColorComponents.swift
// IEC 61966-2-1 — Type-safe color components for HSL/HWB models

public import IEC_61966_Shared

// MARK: - Hue

extension IEC_61966.`2`.`1` {
    /// A hue angle in degrees
    ///
    /// Hue represents the color angle on the color wheel:
    /// - 0° = Red
    /// - 60° = Yellow
    /// - 120° = Green
    /// - 180° = Cyan
    /// - 240° = Blue
    /// - 300° = Magenta
    ///
    /// ## Example
    ///
    /// ```swift
    /// let red = try Hue(0)       // 0°
    /// let blue = try Hue(240)    // 240°
    /// ```
    public struct Hue: Sendable, Hashable {
        /// The hue value in degrees [0, 360)
        public let degrees: Double

        /// Creates a hue from an angle in degrees
        ///
        /// - Parameter degrees: The hue angle in degrees [0, 360)
        /// - Throws: `Hue.Error` if value is outside valid range
        public init(_ degrees: Double) throws(Error) {
            guard degrees >= 0 && degrees < 360 else {
                throw Error(value: degrees)
            }
            self.degrees = degrees
        }

        /// Creates a hue from turns (0-1 representing 0°-360°)
        ///
        /// - Parameter turns: The hue as a fraction of a full rotation [0, 1)
        /// - Throws: `Hue.Error` if value is outside valid range
        public init(turns: Double) throws(Error) {
            try self.init(turns * 360.0)
        }

        /// Creates a hue from radians
        ///
        /// - Parameter radians: The hue angle in radians [0, 2π)
        /// - Throws: `Hue.Error` if value is outside valid range
        public init(radians: Double) throws(Error) {
            try self.init(radians * 180.0 / .pi)
        }

        /// Creates a hue from gradians
        ///
        /// - Parameter gradians: The hue angle in gradians [0, 400)
        /// - Throws: `Hue.Error` if value is outside valid range
        public init(gradians: Double) throws(Error) {
            try self.init(gradians * 0.9)
        }
    }
}

extension IEC_61966.`2`.`1`.Hue {
    /// Error thrown when a hue value is out of valid range [0, 360)
    public struct Error: Swift.Error, Sendable, CustomStringConvertible {
        public let value: Double
        public static let validRange: Range<Double> = 0..<360

        public var description: String {
            "Hue value \(value) is out of valid range \(Self.validRange)"
        }
    }
}

extension IEC_61966.`2`.`1`.Hue: CustomStringConvertible {
    public var description: String {
        "\(degrees)°"
    }
}

extension IEC_61966.`2`.`1`.Hue {
    /// Creates a hue by normalizing any angle to [0, 360)
    ///
    /// Use this when you explicitly want to wrap values.
    ///
    /// - Parameter degrees: The hue angle in degrees (any value)
    public init(normalizing degrees: Double) {
        self.degrees = ((degrees.truncatingRemainder(dividingBy: 360.0)) + 360.0)
            .truncatingRemainder(dividingBy: 360.0)
    }
}

// MARK: - Saturation

extension IEC_61966.`2`.`1` {
    /// Saturation component for HSL color model
    ///
    /// Saturation represents the intensity of the color:
    /// - 0 = Gray (no color)
    /// - 1 = Full color saturation
    ///
    /// ## Example
    ///
    /// ```swift
    /// let gray = try Saturation(0)       // Completely desaturated
    /// let vivid = try Saturation(1)      // Full saturation
    /// let pastel = try Saturation(0.3)   // 30% saturation
    /// ```
    public struct Saturation: Sendable, Hashable {
        /// The saturation value [0, 1]
        public let value: Double

        /// Creates a saturation value
        ///
        /// - Parameter value: Saturation in range [0, 1]
        /// - Throws: `Saturation.Error` if value is outside valid range
        public init(_ value: Double) throws(Error) {
            guard value >= 0 && value <= 1 else {
                throw Error(value: value)
            }
            self.value = value
        }

        /// Creates a saturation value from a percentage
        ///
        /// - Parameter percent: Saturation as percentage [0, 100]
        /// - Throws: `Saturation.Error` if value is outside valid range
        public init(percent: Double) throws(Error) {
            try self.init(percent / 100.0)
        }
    }
}

extension IEC_61966.`2`.`1`.Saturation {
    /// Error thrown when a saturation value is out of valid range [0, 1]
    public struct Error: Swift.Error, Sendable, CustomStringConvertible {
        public let value: Double
        public static let validRange: ClosedRange<Double> = 0...1

        public var description: String {
            "Saturation value \(value) is out of valid range \(Self.validRange)"
        }
    }
}

extension IEC_61966.`2`.`1`.Saturation: CustomStringConvertible {
    public var description: String {
        "\(value * 100)%"
    }
}

extension IEC_61966.`2`.`1`.Saturation {
    /// Creates a saturation by clamping any value to [0, 1]
    ///
    /// Use this when you explicitly want to clamp values from computations.
    ///
    /// - Parameter value: The saturation value (any value, will be clamped)
    public init(clamping value: Double) {
        self.value = min(max(value, 0), 1)
    }
}

// MARK: - Lightness

extension IEC_61966.`2`.`1` {
    /// Lightness component for HSL color model
    ///
    /// Lightness represents the brightness:
    /// - 0 = Black
    /// - 0.5 = Pure color
    /// - 1 = White
    ///
    /// ## Example
    ///
    /// ```swift
    /// let black = try Lightness(0)
    /// let pureColor = try Lightness(0.5)
    /// let white = try Lightness(1)
    /// ```
    public struct Lightness: Sendable, Hashable {
        /// The lightness value [0, 1]
        public let value: Double

        /// Creates a lightness value
        ///
        /// - Parameter value: Lightness in range [0, 1]
        /// - Throws: `Lightness.Error` if value is outside valid range
        public init(_ value: Double) throws(Error) {
            guard value >= 0 && value <= 1 else {
                throw Error(value: value)
            }
            self.value = value
        }

        /// Creates a lightness value from a percentage
        ///
        /// - Parameter percent: Lightness as percentage [0, 100]
        /// - Throws: `Lightness.Error` if value is outside valid range
        public init(percent: Double) throws(Error) {
            try self.init(percent / 100.0)
        }
    }
}

extension IEC_61966.`2`.`1`.Lightness {
    /// Error thrown when a lightness value is out of valid range [0, 1]
    public struct Error: Swift.Error, Sendable, CustomStringConvertible {
        public let value: Double
        public static let validRange: ClosedRange<Double> = 0...1

        public var description: String {
            "Lightness value \(value) is out of valid range \(Self.validRange)"
        }
    }
}

extension IEC_61966.`2`.`1`.Lightness: CustomStringConvertible {
    public var description: String {
        "\(value * 100)%"
    }
}

extension IEC_61966.`2`.`1`.Lightness {
    /// Creates a lightness by clamping any value to [0, 1]
    ///
    /// Use this when you explicitly want to clamp values from computations.
    ///
    /// - Parameter value: The lightness value (any value, will be clamped)
    public init(clamping value: Double) {
        self.value = min(max(value, 0), 1)
    }
}

// MARK: - Whiteness

extension IEC_61966.`2`.`1` {
    /// Whiteness component for HWB color model
    ///
    /// Whiteness represents how much white is mixed into the color:
    /// - 0 = No white
    /// - 1 = Completely white
    ///
    /// ## Example
    ///
    /// ```swift
    /// let pureColor = try Whiteness(0)    // No white added
    /// let tint = try Whiteness(0.3)       // 30% white
    /// ```
    public struct Whiteness: Sendable, Hashable {
        /// The whiteness value [0, 1]
        public let value: Double

        /// Creates a whiteness value
        ///
        /// - Parameter value: Whiteness in range [0, 1]
        /// - Throws: `Whiteness.Error` if value is outside valid range
        public init(_ value: Double) throws(Error) {
            guard value >= 0 && value <= 1 else {
                throw Error(value: value)
            }
            self.value = value
        }

        /// Creates a whiteness value from a percentage
        ///
        /// - Parameter percent: Whiteness as percentage [0, 100]
        /// - Throws: `Whiteness.Error` if value is outside valid range
        public init(percent: Double) throws(Error) {
            try self.init(percent / 100.0)
        }
    }
}

extension IEC_61966.`2`.`1`.Whiteness {
    /// Error thrown when a whiteness value is out of valid range [0, 1]
    public struct Error: Swift.Error, Sendable, CustomStringConvertible {
        public let value: Double
        public static let validRange: ClosedRange<Double> = 0...1

        public var description: String {
            "Whiteness value \(value) is out of valid range \(Self.validRange)"
        }
    }
}

extension IEC_61966.`2`.`1`.Whiteness: CustomStringConvertible {
    public var description: String {
        "\(value * 100)%"
    }
}

extension IEC_61966.`2`.`1`.Whiteness {
    /// Creates a whiteness by clamping any value to [0, 1]
    ///
    /// Use this when you explicitly want to clamp values from computations.
    ///
    /// - Parameter value: The whiteness value (any value, will be clamped)
    public init(clamping value: Double) {
        self.value = min(max(value, 0), 1)
    }
}

// MARK: - Blackness

extension IEC_61966.`2`.`1` {
    /// Blackness component for HWB color model
    ///
    /// Blackness represents how much black is mixed into the color:
    /// - 0 = No black
    /// - 1 = Completely black
    ///
    /// ## Example
    ///
    /// ```swift
    /// let pureColor = try Blackness(0)    // No black added
    /// let shade = try Blackness(0.3)      // 30% black
    /// ```
    public struct Blackness: Sendable, Hashable {
        /// The blackness value [0, 1]
        public let value: Double

        /// Creates a blackness value
        ///
        /// - Parameter value: Blackness in range [0, 1]
        /// - Throws: `Blackness.Error` if value is outside valid range
        public init(_ value: Double) throws(Error) {
            guard value >= 0 && value <= 1 else {
                throw Error(value: value)
            }
            self.value = value
        }

        /// Creates a blackness value from a percentage
        ///
        /// - Parameter percent: Blackness as percentage [0, 100]
        /// - Throws: `Blackness.Error` if value is outside valid range
        public init(percent: Double) throws(Error) {
            try self.init(percent / 100.0)
        }
    }
}

extension IEC_61966.`2`.`1`.Blackness {
    /// Error thrown when a blackness value is out of valid range [0, 1]
    public struct Error: Swift.Error, Sendable, CustomStringConvertible {
        public let value: Double
        public static let validRange: ClosedRange<Double> = 0...1

        public var description: String {
            "Blackness value \(value) is out of valid range \(Self.validRange)"
        }
    }
}

extension IEC_61966.`2`.`1`.Blackness: CustomStringConvertible {
    public var description: String {
        "\(value * 100)%"
    }
}

extension IEC_61966.`2`.`1`.Blackness {
    /// Creates a blackness by clamping any value to [0, 1]
    ///
    /// Use this when you explicitly want to clamp values from computations.
    ///
    /// - Parameter value: The blackness value (any value, will be clamped)
    public init(clamping value: Double) {
        self.value = min(max(value, 0), 1)
    }
}

// MARK: - Type Aliases at Module Level

/// Hue angle for color functions
public typealias Hue = IEC_61966.`2`.`1`.Hue

/// Saturation component for HSL
public typealias Saturation = IEC_61966.`2`.`1`.Saturation

/// Lightness component for HSL
public typealias Lightness = IEC_61966.`2`.`1`.Lightness

/// Whiteness component for HWB
public typealias Whiteness = IEC_61966.`2`.`1`.Whiteness

/// Blackness component for HWB
public typealias Blackness = IEC_61966.`2`.`1`.Blackness
