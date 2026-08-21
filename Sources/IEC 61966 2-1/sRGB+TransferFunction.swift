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

    public struct Error: Swift.Error, Sendable, CustomStringConvertible {
        public let value: Double
        public static let validRange: ClosedRange<Double> = 0...1

        public var description: String {
            "LinearLight value \(value) is out of valid range \(Self.validRange)"
        }
    }
}

extension IEC_61966.`2`.`1`.LinearLight {

    public init(clamping value: Double) {
        self.value = min(max(value, 0), 1)
    }
}

extension IEC_61966.`2`.`1`.sRGB {

    public enum TransferFunction {

        public static let threshold: Double = 0.04045

        public static let linearThreshold: Double = 0.0031308

        public static let linearSlope: Double = 12.92

        public static let gamma: Double = 2.4

        public static let offset: Double = 0.055
    }
}

extension IEC_61966.`2`.`1`.LinearLight {

    public var encoded: Double {
        typealias TF = IEC_61966.`2`.`1`.sRGB.TransferFunction
        if value <= TF.linearThreshold {
            return TF.linearSlope * value
        } else {
            return (1 + TF.offset) * ISO_9899.Math.pow(value, 1.0 / TF.gamma) - TF.offset
        }
    }
}

extension IEC_61966.`2`.`1`.Red {

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

    public var encoded: IEC_61966.`2`.`1`.sRGB {
        IEC_61966.`2`.`1`.sRGB(
            r: r.encoded,
            g: g.encoded,
            b: b.encoded
        )
    }
}

extension IEC_61966.`2`.`1`.sRGB {

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
