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

    public init(normalizing degrees: Double) {
        self.degrees = ((degrees.truncatingRemainder(dividingBy: 360.0)) + 360.0)
            .truncatingRemainder(dividingBy: 360.0)
    }
}

extension IEC_61966.`2`.`1` {

    public struct Saturation: Sendable, Hashable {

        public let value: Double

        public init(_ value: Double) throws(Error) {
            guard value >= 0 && value <= 1 else {
                throw Error(value: value)
            }
            self.value = value
        }

        public init(percent: Double) throws(Error) {
            try self.init(percent / 100.0)
        }
    }
}

extension IEC_61966.`2`.`1`.Saturation {

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

    public init(clamping value: Double) {
        self.value = min(max(value, 0), 1)
    }
}

extension IEC_61966.`2`.`1` {

    public struct Lightness: Sendable, Hashable {

        public let value: Double

        public init(_ value: Double) throws(Error) {
            guard value >= 0 && value <= 1 else {
                throw Error(value: value)
            }
            self.value = value
        }

        public init(percent: Double) throws(Error) {
            try self.init(percent / 100.0)
        }
    }
}

extension IEC_61966.`2`.`1`.Lightness {

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

    public init(clamping value: Double) {
        self.value = min(max(value, 0), 1)
    }
}

extension IEC_61966.`2`.`1` {

    public struct Whiteness: Sendable, Hashable {

        public let value: Double

        public init(_ value: Double) throws(Error) {
            guard value >= 0 && value <= 1 else {
                throw Error(value: value)
            }
            self.value = value
        }

        public init(percent: Double) throws(Error) {
            try self.init(percent / 100.0)
        }
    }
}

extension IEC_61966.`2`.`1`.Whiteness {

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

    public init(clamping value: Double) {
        self.value = min(max(value, 0), 1)
    }
}

extension IEC_61966.`2`.`1` {

    public struct Blackness: Sendable, Hashable {

        public let value: Double

        public init(_ value: Double) throws(Error) {
            guard value >= 0 && value <= 1 else {
                throw Error(value: value)
            }
            self.value = value
        }

        public init(percent: Double) throws(Error) {
            try self.init(percent / 100.0)
        }
    }
}

extension IEC_61966.`2`.`1`.Blackness {

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

    public init(clamping value: Double) {
        self.value = min(max(value, 0), 1)
    }
}

public typealias Hue = IEC_61966.`2`.`1`.Hue

public typealias Saturation = IEC_61966.`2`.`1`.Saturation

public typealias Lightness = IEC_61966.`2`.`1`.Lightness

public typealias Whiteness = IEC_61966.`2`.`1`.Whiteness

public typealias Blackness = IEC_61966.`2`.`1`.Blackness
