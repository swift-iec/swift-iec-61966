public import IEC_61966_Shared

extension IEC_61966.`2`.`1` {

    public struct Hue: Sendable, Hashable {

        public let degrees: Double

        public init(_ degrees: Double) throws(Error) {
            guard degrees >= 0 && degrees < 360 else {
                throw Error(value: degrees)
            }
            self.degrees = degrees
        }

        public init(turns: Double) throws(Error) {
            try self.init(turns * 360.0)
        }

        public init(radians: Double) throws(Error) {
            try self.init(radians * 180.0 / .pi)
        }

        public init(gradians: Double) throws(Error) {
            try self.init(gradians * 0.9)
        }
    }
}

extension IEC_61966.`2`.`1`.Hue {
}

extension IEC_61966.`2`.`1`.Hue.Error {
    public static let validRange: Range<Double> = 0..<360

    public var description: String {
        "Hue value \(value) is out of valid range \(Self.validRange)"
    }
}

extension IEC_61966.`2`.`1`.Hue: CustomStringConvertible {
    public var description: String {
        "\(degrees)°"
    }
}

extension IEC_61966.`2`.`1`.Hue {

    public init(normalizing degrees: Double) {
        self.degrees = ((degrees.truncatingRemainder(dividingBy: 360.0)) + 360.0)
            .truncatingRemainder(dividingBy: 360.0)
    }
}

extension IEC_61966.`2`.`1` {
}

extension IEC_61966.`2`.`1`.Saturation {
}

extension IEC_61966.`2`.`1`.Saturation.Error {
    public static let validRange: ClosedRange<Double> = 0...1

    public var description: String {
        "Saturation value \(value) is out of valid range \(Self.validRange)"
    }
}

extension IEC_61966.`2`.`1`.Saturation: CustomStringConvertible {
    public var description: String {
        "\(value * 100)%"
    }
}

extension IEC_61966.`2`.`1`.Saturation {

    public init(clamping value: Double) {
        self.value = value.isNaN ? 0 : min(max(value, 0), 1)
    }
}

extension IEC_61966.`2`.`1` {
}

extension IEC_61966.`2`.`1`.Lightness {
}

extension IEC_61966.`2`.`1`.Lightness.Error {
    public static let validRange: ClosedRange<Double> = 0...1

    public var description: String {
        "Lightness value \(value) is out of valid range \(Self.validRange)"
    }
}

extension IEC_61966.`2`.`1`.Lightness: CustomStringConvertible {
    public var description: String {
        "\(value * 100)%"
    }
}

extension IEC_61966.`2`.`1`.Lightness {

    public init(clamping value: Double) {
        self.value = value.isNaN ? 0 : min(max(value, 0), 1)
    }
}

extension IEC_61966.`2`.`1` {
}

extension IEC_61966.`2`.`1`.Whiteness {
}

extension IEC_61966.`2`.`1`.Whiteness.Error {
    public static let validRange: ClosedRange<Double> = 0...1

    public var description: String {
        "Whiteness value \(value) is out of valid range \(Self.validRange)"
    }
}

extension IEC_61966.`2`.`1`.Whiteness: CustomStringConvertible {
    public var description: String {
        "\(value * 100)%"
    }
}

extension IEC_61966.`2`.`1`.Whiteness {

    public init(clamping value: Double) {
        self.value = value.isNaN ? 0 : min(max(value, 0), 1)
    }
}

extension IEC_61966.`2`.`1` {
}

extension IEC_61966.`2`.`1`.Blackness {
}

extension IEC_61966.`2`.`1`.Blackness.Error {
    public static let validRange: ClosedRange<Double> = 0...1

    public var description: String {
        "Blackness value \(value) is out of valid range \(Self.validRange)"
    }
}

extension IEC_61966.`2`.`1`.Blackness: CustomStringConvertible {
    public var description: String {
        "\(value * 100)%"
    }
}

extension IEC_61966.`2`.`1`.Blackness {

    public init(clamping value: Double) {
        self.value = value.isNaN ? 0 : min(max(value, 0), 1)
    }
}

public typealias Hue = IEC_61966.`2`.`1`.Hue

public typealias Saturation = IEC_61966.`2`.`1`.Saturation

public typealias Lightness = IEC_61966.`2`.`1`.Lightness

public typealias Whiteness = IEC_61966.`2`.`1`.Whiteness

public typealias Blackness = IEC_61966.`2`.`1`.Blackness
