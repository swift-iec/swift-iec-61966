internal import ASCII_Primitives
public import IEC_61966_Shared

extension IEC_61966.`2`.`1` {

    public struct sRGB: Sendable, Hashable {

        public var r: Double

        public var g: Double

        public var b: Double

        public init(red: Red, green: Green, blue: Blue) {
            self.r = red.value
            self.g = green.value
            self.b = blue.value
        }

        public init(r: Double, g: Double, b: Double) {
            self.r = min(max(r, 0), 1)
            self.g = min(max(g, 0), 1)
            self.b = min(max(b, 0), 1)
        }
    }
}

extension IEC_61966.`2`.`1` {

    public struct Red: Sendable, Hashable {

        public let value: Double

        public init(_ value: Double) throws(Error) {
            guard value >= 0 && value <= 1 else {
                throw Error(value: value)
            }
            self.value = value
        }
    }
}

extension IEC_61966.`2`.`1`.Red {

    public struct Error: Swift.Error, Sendable, CustomStringConvertible {
        public let value: Double
        public static let validRange: ClosedRange<Double> = 0...1

        public var description: String {
            "Red channel value \(value) is out of valid range \(Self.validRange)"
        }
    }
}

extension IEC_61966.`2`.`1`.Red {

    public init(clamping value: Double) {
        self.value = min(max(value, 0), 1)
    }
}

extension IEC_61966.`2`.`1` {

    public struct Green: Sendable, Hashable {

        public let value: Double

        public init(_ value: Double) throws(Error) {
            guard value >= 0 && value <= 1 else {
                throw Error(value: value)
            }
            self.value = value
        }
    }
}

extension IEC_61966.`2`.`1`.Green {

    public struct Error: Swift.Error, Sendable, CustomStringConvertible {
        public let value: Double
        public static let validRange: ClosedRange<Double> = 0...1

        public var description: String {
            "Green channel value \(value) is out of valid range \(Self.validRange)"
        }
    }
}

extension IEC_61966.`2`.`1`.Green {

    public init(clamping value: Double) {
        self.value = min(max(value, 0), 1)
    }
}

extension IEC_61966.`2`.`1` {

    public struct Blue: Sendable, Hashable {

        public let value: Double

        public init(_ value: Double) throws(Error) {
            guard value >= 0 && value <= 1 else {
                throw Error(value: value)
            }
            self.value = value
        }
    }
}

extension IEC_61966.`2`.`1`.Blue {

    public struct Error: Swift.Error, Sendable, CustomStringConvertible {
        public let value: Double
        public static let validRange: ClosedRange<Double> = 0...1

        public var description: String {
            "Blue channel value \(value) is out of valid range \(Self.validRange)"
        }
    }
}

extension IEC_61966.`2`.`1`.Blue {

    public init(clamping value: Double) {
        self.value = min(max(value, 0), 1)
    }
}

extension IEC_61966.`2`.`1`.sRGB {

    public init(gray: Double) {
        self.r = gray
        self.g = gray
        self.b = gray
    }
}

extension IEC_61966.`2`.`1`.sRGB {

    public static let black = Self(r: 0, g: 0, b: 0)

    public static let white = Self(r: 1, g: 1, b: 1)

    public static let red = Self(r: 1, g: 0, b: 0)

    public static let green = Self(r: 0, g: 1, b: 0)

    public static let blue = Self(r: 0, g: 0, b: 1)

    public static let cyan = Self(r: 0, g: 1, b: 1)

    public static let magenta = Self(r: 1, g: 0, b: 1)

    public static let yellow = Self(r: 1, g: 1, b: 0)
}

extension IEC_61966.`2`.`1`.sRGB {

    public init(r255 r: Int, g255 g: Int, b255 b: Int) {
        self.r = Double(r) / 255.0
        self.g = Double(g) / 255.0
        self.b = Double(b) / 255.0
    }

    public var r255: Int {
        Int((r * 255).rounded().clamped(to: 0...255))
    }

    public var g255: Int {
        Int((g * 255).rounded().clamped(to: 0...255))
    }

    public var b255: Int {
        Int((b * 255).rounded().clamped(to: 0...255))
    }
}

extension IEC_61966.`2`.`1`.sRGB {

    public init?(hex: String) {
        var hexString = hex

        while hexString.first?.isWhitespace == true {
            hexString.removeFirst()
        }
        while hexString.last?.isWhitespace == true {
            hexString.removeLast()
        }
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }

        guard let value = UInt64(hexString, radix: 16) else {
            return nil
        }

        switch hexString.count {
        case 3:
            let r = Double((value >> 8) & 0xF) / 15.0
            let g = Double((value >> 4) & 0xF) / 15.0
            let b = Double(value & 0xF) / 15.0
            self.init(r: r, g: g, b: b)

        case 6:
            let r = Double((value >> 16) & 0xFF) / 255.0
            let g = Double((value >> 8) & 0xFF) / 255.0
            let b = Double(value & 0xFF) / 255.0
            self.init(r: r, g: g, b: b)

        default:
            return nil
        }
    }

    public var hex: String {

        func digit(_ nibble: Int) -> Character {

            Character(UnicodeScalar(ASCII.Hexadecimal.code(UInt8(nibble & 0xF), case: .upper)!))
        }
        let r = r255
        let g = g255
        let b = b255
        return "#" + String(digit((r >> 4) & 0xF)) + String(digit(r & 0xF))
            + String(digit((g >> 4) & 0xF)) + String(digit(g & 0xF))
            + String(digit((b >> 4) & 0xF)) + String(digit(b & 0xF))
    }
}

extension Double {
    func clamped(to range: ClosedRange<Double>) -> Double {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
