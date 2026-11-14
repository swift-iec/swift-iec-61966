public import IEC_61966_Shared

extension IEC_61966.`2`.`1`.SRGB {

    /// The 8-bit encoding of a component, taken from and back to linear light: the encoded component
    /// `TransferFunction.encoded(_:)` makes, times 255, rounded. Both directions are tables built once, so no
    /// power function runs per value.
    public enum Level {}
}

extension IEC_61966.`2`.`1`.SRGB.Level {

    /// The 8-bit level of a linear light: `TransferFunction.encoded(linear) * 255`, rounded to the nearest
    /// integer with halves up and clamped to 0…255, for every `Double`, at the exact thresholds too.
    /// NaN, −∞, zero and every negative give 0; 1, every value above it and +∞ give 255.
    @inlinable
    public static func encoded(_ linear: Double) -> UInt8 {
        guard linear >= Self.Bucket<Double>.lowest else { return 0 }
        guard linear < 1 else { return 255 }
        let bucket = Self.Table.double[Int(truncatingIfNeeded: linear.bitPattern >> 44) &- 258_560]
        return linear >= bucket.threshold ? bucket.level &+ 1 : bucket.level
    }

    /// The 8-bit level of a single-precision linear light: the level of the same value as a `Double`, so the
    /// encoding is worked in double precision, as `TransferFunction.encoded(_:)` for `Float` is. NaN, −∞, zero
    /// and every negative give 0; 1, every value above it and +∞ give 255.
    @inlinable
    public static func encoded(_ linear: Float) -> UInt8 {
        guard linear >= Self.Bucket<Float>.lowest else { return 0 }
        guard linear < 1 else { return 255 }
        let bucket = Self.Table.float[Int(truncatingIfNeeded: linear.bitPattern >> 15) &- 29_184]
        return linear >= bucket.threshold ? bucket.level &+ 1 : bucket.level
    }

    /// The linear light of an 8-bit level: `TransferFunction.linear(Double(level) / 255)`.
    @inlinable
    public static func linear(_ level: UInt8) -> Double {
        Self.Table.linear[Int(level)]
    }

    /// The linear light of an 8-bit level in single precision: the `Double` one, rounded to `Float`.
    @inlinable
    public static func linear(_ level: UInt8) -> Float {
        Self.Table.single[Int(level)]
    }
}
