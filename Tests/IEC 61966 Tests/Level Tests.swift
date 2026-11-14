import IEC_61966
import Testing

enum `Level Tests` {}

extension `Level Tests` {
    @Suite
    struct `The 8-bit level of linear light is the plain path` {
        private typealias Level = IEC_61966.`2`.`1`.SRGB.Level
        private typealias TF = IEC_61966.`2`.`1`.SRGB.TransferFunction

        /// One power function per value: the encoded component times 255, rounded with halves up, clamped.
        private static func plain(_ linear: Double) -> UInt8 {
            let scaled = (TF.encoded(linear) * 255).rounded()
            guard scaled >= 0 else { return 0 }
            guard scaled < 255 else { return 255 }
            return UInt8(scaled)
        }

        /// The smallest value of the precision whose plain level is at least `level`, found by bisection.
        private static func threshold<Value: BinaryFloatingPoint>(
            _ level: UInt8,
            _ plain: (Value) -> UInt8
        ) -> Value {
            var below: Value = 0
            var above: Value = 1
            while below.nextUp < above {
                let middle = below + (above - below) / 2
                if plain(middle) >= level { above = middle } else { below = middle }
            }
            return above
        }

        @Test
        func `every threshold and its neighbours give the plain level, in double precision`() {
            (UInt8(1)...255).forEach { level in
                let threshold: Double = Self.threshold(level) { Self.plain($0) }
                #expect(Self.plain(threshold) == level && Self.plain(threshold.nextDown) == level - 1)
                for value in [threshold.nextDown, threshold, threshold.nextUp] {
                    #expect(Level.encoded(value) == Self.plain(value), "at \(value)")
                }
            }
        }

        @Test
        func `every threshold and its neighbours give the plain level, in single precision`() {
            (UInt8(1)...255).forEach { level in
                let threshold: Float = Self.threshold(level) { Self.plain(Double($0)) }
                #expect(Self.plain(Double(threshold)) == level && Self.plain(Double(threshold.nextDown)) == level - 1)
                for value in [threshold.nextDown, threshold, threshold.nextUp] {
                    #expect(Level.encoded(value) == Self.plain(Double(value)), "at \(value)")
                }
            }
        }

        @Test
        func `a dense sweep of single-precision values gives the plain level`() {
            var mismatches = 0
            for bits in stride(from: Float(0x1p-14).bitPattern, through: Float(1.5).bitPattern, by: 37) {
                let value = Float(bitPattern: bits)
                if Level.encoded(value) != Self.plain(Double(value)) { mismatches += 1 }
            }
            #expect(mismatches == 0)
        }

        @Test
        func `a dense sweep of double-precision values gives the plain level`() {
            var mismatches = 0
            let step = (Double(1.5).bitPattern - Double(0x1p-14).bitPattern) / 3_000_000 | 1
            for bits in stride(from: Double(0x1p-14).bitPattern, through: Double(1.5).bitPattern, by: Int(step)) {
                let value = Double(bitPattern: bits)
                if Level.encoded(value) != Self.plain(value) { mismatches += 1 }
            }
            #expect(mismatches == 0)
        }

        @Test
        func `NaN, negatives and minus infinity give 0; one, above one and infinity give 255`() {
            let doubles: [Double] = [
                .nan, -.nan, .signalingNaN, -.infinity, -.greatestFiniteMagnitude, -1, -0.0, 0,
                .leastNonzeroMagnitude, .leastNormalMagnitude, 0x1p-13, Double(0x1p-13).nextDown,
                Double(1).nextDown, 1, Double(1).nextUp, 2, .greatestFiniteMagnitude, .infinity,
            ]
            for value in doubles {
                #expect(Level.encoded(value) == Self.plain(value), "at \(value)")
                #expect(Level.encoded(Float(value)) == Self.plain(Double(Float(value))), "at \(value)")
            }
            #expect(Level.encoded(Double.nan) == 0 && Level.encoded(Float.nan) == 0)
            #expect(Level.encoded(-Double.infinity) == 0 && Level.encoded(-Float(0.5)) == 0)
            #expect(Level.encoded(Double(1)) == 255 && Level.encoded(Float(7)) == 255)
            #expect(Level.encoded(Double.infinity) == 255 && Level.encoded(Float.infinity) == 255)
        }
    }
}

extension `Level Tests` {
    @Suite
    struct `The linear light of an 8-bit level` {
        private typealias Level = IEC_61966.`2`.`1`.SRGB.Level
        private typealias TF = IEC_61966.`2`.`1`.SRGB.TransferFunction

        @Test
        func `each level's linear light is the transfer function of the level over 255`() {
            (UInt8.min...UInt8.max).forEach { level in
                let double: Double = Level.linear(level)
                let single: Float = Level.linear(level)
                #expect(double == TF.linear(Double(level) / 255))
                #expect(single == Float(TF.linear(Double(level) / 255)))
            }
        }

        @Test
        func `every level comes back from its own linear light, in both precisions`() {
            (UInt8.min...UInt8.max).forEach { level in
                let double: Double = Level.linear(level)
                let single: Float = Level.linear(level)
                #expect(Level.encoded(double) == level)
                #expect(Level.encoded(single) == level)
            }
        }
    }
}

extension `Level Tests` {
    @Suite
    struct `The standard's matrices between CIE XYZ and linear sRGB` {
        private typealias Matrix = IEC_61966.`2`.`1`.SRGB.Matrix

        @Test
        func `forward times reverse is the identity to the printed four decimals`() {
            (0..<3).forEach { row in
                (0..<3).forEach { column in
                    let forward = (0..<3).reduce(0.0) { $0 + Matrix.forward[row][$1] * Matrix.reverse[$1][column] }
                    let reverse = (0..<3).reduce(0.0) { $0 + Matrix.reverse[row][$1] * Matrix.forward[$1][column] }
                    let identity: Double = row == column ? 1 : 0
                    #expect(abs(forward - identity) < 5e-4, "forward·reverse[\(row)][\(column)] = \(forward)")
                    #expect(abs(reverse - identity) < 5e-4, "reverse·forward[\(row)][\(column)] = \(reverse)")
                }
            }
        }

        @Test
        func `the reverse matrix takes white to D65 with Y at 1`() {
            let white = Matrix.reverse.map { $0.reduce(0, +) }
            #expect(abs(white[0] - 0.9505) < 1e-4)
            #expect(abs(white[1] - 1) < 1e-4)
            #expect(abs(white[2] - 1.0890) < 1e-4)
        }
    }
}
