public import IEC_61966_Shared
import ISO_9899

extension IEC_61966.`2`.`1` {

    public struct LinearLight: Sendable, Hashable {

        public let value: Double

        public init(_ value: Double) throws(Error) {
            guard value >= 0 && value <= 1 else {
                throw Error(value: value)
            }
            self.value = value
        }
    }
}

extension IEC_61966.`2`.`1`.LinearLight {

    public struct Error: Swift::Error, Sendable, CustomStringConvertible {
        public let value: Double
    }
}

extension IEC_61966.`2`.`1`.LinearLight.Error {
    public static let validRange: ClosedRange<Double> = 0...1

    public var description: String {
        "LinearLight value \(value) is out of valid range \(Self.validRange)"
    }
}

extension IEC_61966.`2`.`1`.LinearLight {

    public init(clamping value: Double) {
        self.value = value.isNaN ? 0 : min(max(value, 0), 1)
    }
}

extension IEC_61966.`2`.`1`.SRGB {

    public enum TransferFunction {}
}

extension IEC_61966.`2`.`1`.SRGB.TransferFunction {
    public static let threshold: Double = 0.04045

    public static let linearThreshold: Double = 0.0031308

    public static let linearSlope: Double = 12.92

    public static let gamma: Double = 2.4

    public static let offset: Double = 0.055
}

extension IEC_61966.`2`.`1`.SRGB.TransferFunction {
    /// The linear light of an encoded component: the component over 12.92 up to the threshold, and a
    /// power of 2.4 above it. Nothing is clamped, so a component outside 0…1 follows the same two pieces.
    public static func linear(_ encoded: Double) -> Double {
        guard encoded > threshold else { return encoded / linearSlope }
        return ISO_9899.Math.pow((encoded + offset) / (1 + offset), gamma)
    }

    /// The encoded component of a linear light: 12.92 times it up to the linear threshold, and a root
    /// of 2.4 above it. Nothing is clamped.
    public static func encoded(_ linear: Double) -> Double {
        guard linear > linearThreshold else { return linearSlope * linear }
        return (1 + offset) * ISO_9899.Math.pow(linear, 1.0 / gamma) - offset
    }

    /// `linear(_:)` in single precision, for buffers of `Float` components.
    public static func linear(_ encoded: Float) -> Float {
        guard encoded > Float(threshold) else { return encoded / Float(linearSlope) }
        return ISO_9899.Math.pow((encoded + Float(offset)) / (1 + Float(offset)), Float(gamma))
    }

    /// `encoded(_:)` in single precision, for buffers of `Float` components.
    public static func encoded(_ linear: Float) -> Float {
        guard linear > Float(linearThreshold) else { return Float(linearSlope) * linear }
        return (1 + Float(offset)) * ISO_9899.Math.pow(linear, 1 / Float(gamma)) - Float(offset)
    }
}

extension IEC_61966.`2`.`1`.LinearLight {

    public var encoded: Double { IEC_61966.`2`.`1`.SRGB.TransferFunction.encoded(value) }
}

extension IEC_61966.`2`.`1`.Red {

    public var linear: IEC_61966.`2`.`1`.LinearLight {
        IEC_61966.`2`.`1`.LinearLight(clamping: IEC_61966.`2`.`1`.SRGB.TransferFunction.linear(value))
    }
}

extension IEC_61966.`2`.`1`.Green {

    public var linear: IEC_61966.`2`.`1`.LinearLight {
        IEC_61966.`2`.`1`.LinearLight(clamping: IEC_61966.`2`.`1`.SRGB.TransferFunction.linear(value))
    }
}

extension IEC_61966.`2`.`1`.Blue {

    public var linear: IEC_61966.`2`.`1`.LinearLight {
        IEC_61966.`2`.`1`.LinearLight(clamping: IEC_61966.`2`.`1`.SRGB.TransferFunction.linear(value))
    }
}

extension IEC_61966.`2`.`1` {

    public struct LinearSRGB: Sendable, Hashable {

        public let r: LinearLight

        public let g: LinearLight

        public let b: LinearLight

        public init(r: LinearLight, g: LinearLight, b: LinearLight) {
            self.r = r
            self.g = g
            self.b = b
        }
    }
}

extension IEC_61966.`2`.`1`.LinearSRGB {

    public init(r: Double, g: Double, b: Double) {
        self.r = IEC_61966.`2`.`1`.LinearLight(clamping: r)
        self.g = IEC_61966.`2`.`1`.LinearLight(clamping: g)
        self.b = IEC_61966.`2`.`1`.LinearLight(clamping: b)
    }

    public var encoded: IEC_61966.`2`.`1`.SRGB {
        IEC_61966.`2`.`1`.SRGB(
            r: r.encoded,
            g: g.encoded,
            b: b.encoded
        )
    }
}

extension IEC_61966.`2`.`1`.SRGB {

    public var linear: IEC_61966.`2`.`1`.LinearSRGB {
        IEC_61966.`2`.`1`.LinearSRGB(
            r: IEC_61966.`2`.`1`.Red(clamping: r).linear,
            g: IEC_61966.`2`.`1`.Green(clamping: g).linear,
            b: IEC_61966.`2`.`1`.Blue(clamping: b).linear
        )
    }

    public init(_ linear: IEC_61966.`2`.`1`.LinearSRGB) {
        self.r = linear.r.encoded
        self.g = linear.g.encoded
        self.b = linear.b.encoded
    }
}
