// sRGB+TransferFunction.swift
// IEC 61966-2-1 Transfer Function (Gamma)

public import IEC_61966_Shared
import ISO_9899

// MARK: - Linear Light Types

extension IEC_61966.`2`.`1` {
    /// Linear light value (scene-referred, before gamma encoding)
    ///
    /// Linear light values represent physical light intensity before
    /// the sRGB transfer function is applied. They are suitable for
    /// physically-based lighting calculations.
    ///
    /// Value is in range [0, 1]:
    /// - 0 = no light
    /// - 1 = reference white
    ///
    /// ## Example
    ///
    /// ```swift
    /// let halfLight = try LinearLight(0.5)
    /// let encoded = halfLight.encoded  // Apply gamma encoding
    /// ```
    public struct LinearLight: Sendable, Hashable {
        /// The linear light value [0, 1]
        public let value: Double

        /// Creates a linear light value
        ///
        /// - Parameter value: Linear light in range [0, 1]
        /// - Throws: `LinearLight.Error` if value is outside valid range
        public init(_ value: Double) throws(Error) {
            guard value >= 0 && value <= 1 else {
                throw Error(value: value)
            }
            self.value = value
        }
    }
}

extension IEC_61966.`2`.`1`.LinearLight {
    /// Error thrown when a linear light value is out of valid range [0, 1]
    public struct Error: Swift.Error, Sendable, CustomStringConvertible {
        public let value: Double
        public static let validRange: ClosedRange<Double> = 0...1

        public var description: String {
            "LinearLight value \(value) is out of valid range \(Self.validRange)"
        }
    }
}

extension IEC_61966.`2`.`1`.LinearLight {
    /// Creates a linear light value by clamping any value to [0, 1]
    ///
    /// - Parameter value: The linear light value (any value, will be clamped)
    public init(clamping value: Double) {
        self.value = min(max(value, 0), 1)
    }
}

// MARK: - Transfer Function

extension IEC_61966.`2`.`1`.sRGB {
    /// sRGB transfer function constants
    ///
    /// Per IEC 61966-2-1, the sRGB transfer function is approximately gamma 2.2,
    /// but with a linear segment near black for better shadow reproduction.
    public enum TransferFunction {
        /// Threshold below which the linear segment is used (encoded domain)
        public static let threshold: Double = 0.04045

        /// Threshold in linear domain
        public static let linearThreshold: Double = 0.0031308

        /// Linear segment slope
        public static let linearSlope: Double = 12.92

        /// Gamma curve exponent
        public static let gamma: Double = 2.4

        /// Offset for gamma curve
        public static let offset: Double = 0.055
    }
}

// MARK: - Encoding (Linear → sRGB)

extension IEC_61966.`2`.`1`.LinearLight {
    /// sRGB-encoded value after applying the transfer function
    ///
    /// Applies the sRGB gamma encoding per IEC 61966-2-1 Section 4.5:
    /// ```
    /// if linear <= 0.0031308:
    ///     encoded = 12.92 × linear
    /// else:
    ///     encoded = 1.055 × linear^(1/2.4) - 0.055
    /// ```
    public var encoded: Double {
        typealias TF = IEC_61966.`2`.`1`.sRGB.TransferFunction
        if value <= TF.linearThreshold {
            return TF.linearSlope * value
        } else {
            return (1 + TF.offset) * ISO_9899.Math.pow(value, 1.0 / TF.gamma) - TF.offset
        }
    }
}

// MARK: - Decoding (sRGB → Linear)

extension IEC_61966.`2`.`1`.Red {
    /// Linear light value after applying the inverse transfer function
    ///
    /// Applies the inverse sRGB gamma decoding per IEC 61966-2-1 Section 4.5:
    /// ```
    /// if encoded <= 0.04045:
    ///     linear = encoded / 12.92
    /// else:
    ///     linear = ((encoded + 0.055) / 1.055)^2.4
    /// ```
    public var linear: IEC_61966.`2`.`1`.LinearLight {
        typealias TF = IEC_61966.`2`.`1`.sRGB.TransferFunction
        let linearValue: Double
        if value <= TF.threshold {
            linearValue = value / TF.linearSlope
        } else {
            linearValue = ISO_9899.Math.pow((value + TF.offset) / (1 + TF.offset), TF.gamma)
        }
        return IEC_61966.`2`.`1`.LinearLight(clamping: linearValue)
    }
}

extension IEC_61966.`2`.`1`.Green {
    /// Linear light value after applying the inverse transfer function
    public var linear: IEC_61966.`2`.`1`.LinearLight {
        typealias TF = IEC_61966.`2`.`1`.sRGB.TransferFunction
        let linearValue: Double
        if value <= TF.threshold {
            linearValue = value / TF.linearSlope
        } else {
            linearValue = ISO_9899.Math.pow((value + TF.offset) / (1 + TF.offset), TF.gamma)
        }
        return IEC_61966.`2`.`1`.LinearLight(clamping: linearValue)
    }
}

extension IEC_61966.`2`.`1`.Blue {
    /// Linear light value after applying the inverse transfer function
    public var linear: IEC_61966.`2`.`1`.LinearLight {
        typealias TF = IEC_61966.`2`.`1`.sRGB.TransferFunction
        let linearValue: Double
        if value <= TF.threshold {
            linearValue = value / TF.linearSlope
        } else {
            linearValue = ISO_9899.Math.pow((value + TF.offset) / (1 + TF.offset), TF.gamma)
        }
        return IEC_61966.`2`.`1`.LinearLight(clamping: linearValue)
    }
}

// MARK: - Linear sRGB Color

extension IEC_61966.`2`.`1` {
    /// Linear sRGB color (scene-referred, before gamma encoding)
    ///
    /// Represents an sRGB color in linear light space, suitable for
    /// physically-based lighting calculations, blending, and compositing.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let linearRed = try LinearSRGB(
    ///     r: LinearLight(1),
    ///     g: LinearLight(0),
    ///     b: LinearLight(0)
    /// )
    /// let encoded = linearRed.encoded  // Convert to sRGB
    /// ```
    public struct LinearSRGB: Sendable, Hashable {
        /// Red channel in linear light
        public let r: LinearLight

        /// Green channel in linear light
        public let g: LinearLight

        /// Blue channel in linear light
        public let b: LinearLight

        /// Creates a linear sRGB color from typed components
        public init(r: LinearLight, g: LinearLight, b: LinearLight) {
            self.r = r
            self.g = g
            self.b = b
        }
    }
}

extension IEC_61966.`2`.`1`.LinearSRGB {
    /// Convenience: Create a linear sRGB color from Double values
    ///
    /// - Parameters:
    ///   - r: Red component (clamped to 0-1)
    ///   - g: Green component (clamped to 0-1)
    ///   - b: Blue component (clamped to 0-1)
    public init(r: Double, g: Double, b: Double) {
        self.r = IEC_61966.`2`.`1`.LinearLight(clamping: r)
        self.g = IEC_61966.`2`.`1`.LinearLight(clamping: g)
        self.b = IEC_61966.`2`.`1`.LinearLight(clamping: b)
    }

    /// sRGB-encoded representation of this linear color
    public var encoded: IEC_61966.`2`.`1`.sRGB {
        IEC_61966.`2`.`1`.sRGB(
            r: r.encoded,
            g: g.encoded,
            b: b.encoded
        )
    }
}

// MARK: - sRGB to Linear Conversion

extension IEC_61966.`2`.`1`.sRGB {
    /// Linear light representation of this color
    ///
    /// Decodes the sRGB values to linear light values suitable for
    /// physically-based lighting calculations.
    public var linear: IEC_61966.`2`.`1`.LinearSRGB {
        IEC_61966.`2`.`1`.LinearSRGB(
            r: IEC_61966.`2`.`1`.Red(clamping: r).linear,
            g: IEC_61966.`2`.`1`.Green(clamping: g).linear,
            b: IEC_61966.`2`.`1`.Blue(clamping: b).linear
        )
    }

    /// Create sRGB from linear light values
    ///
    /// Encodes linear light values to sRGB.
    ///
    /// - Parameter linear: Linear light color
    public init(_ linear: IEC_61966.`2`.`1`.LinearSRGB) {
        self.r = linear.r.encoded
        self.g = linear.g.encoded
        self.b = linear.b.encoded
    }
}
