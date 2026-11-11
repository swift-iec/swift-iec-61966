import IEC_61966
import Testing

enum `Transfer Function Boundary Tests` {}

extension `Transfer Function Boundary Tests` {
    @Suite
    struct `sRGB transfer function boundaries` {
        private typealias Linear = IEC_61966.`2`.`1`.LinearLight
        private typealias TF = IEC_61966.`2`.`1`.SRGB.TransferFunction

        @Test
        func `the endpoints encode to themselves`() throws {
            #expect(try Linear(0).encoded == 0)
            #expect(abs(try Linear(1).encoded - 1) < 1e-12)
        }

        @Test
        func `the two pieces meet at the linear threshold`() throws {
            let below = try Linear(TF.linearThreshold).encoded
            let above = try Linear(TF.linearThreshold.nextUp).encoded
            #expect(abs(below - TF.threshold) < 1e-4)
            #expect(abs(above - below) < 1e-6)
        }

        @Test
        func `encoding is monotonic across the whole range`() throws {
            var previous = -1.0
            for step in 0...1000 {
                let encoded = try Linear(Double(step) / 1000).encoded
                #expect(encoded >= previous)
                previous = encoded
            }
        }

        @Test
        func `out of range values are rejected, including NaN`() {
            for value in [-0.001, 1.001, Double.nan, .infinity] {
                #expect(throws: Linear.Error.self) { try Linear(value) }
            }
        }

        @Test
        func `clamping always lands inside the valid range, including for NaN`() {
            for value in [-5.0, 5.0, Double.nan, .infinity, -.infinity] {
                let clamped = Linear(clamping: value).value
                #expect((0...1).contains(clamped), "clamping \(value) gave \(clamped)")
            }
        }

        @Test
        func `a NaN channel reads as zero instead of trapping`() {
            let color = IEC_61966.SRGB(r: .nan, g: 0.5, b: 1)
            #expect(color.r255 == 0)
            #expect(color.b255 == 255)
        }
    }
}

extension `Transfer Function Boundary Tests` {
    @Suite
    struct `The transfer function as plain functions` {
        private typealias TF = IEC_61966.`2`.`1`.SRGB.TransferFunction

        @Test
        func `the plain functions are the ones the component types use`() throws {
            try (0...255).forEach { level in
                let encoded = Double(level) / 255
                let red = try IEC_61966.`2`.`1`.Red(encoded)
                let light = try IEC_61966.`2`.`1`.LinearLight(encoded)
                #expect(TF.linear(encoded) == red.linear.value)
                #expect(TF.encoded(encoded) == light.encoded)
            }
        }

        @Test
        func `linear and encoded undo each other on every 8-bit level, in both precisions`() {
            (0...255).forEach { level in
                let double = Double(level) / 255
                #expect(abs(TF.encoded(TF.linear(double)) - double) < 1e-12)
                let single = Float(level) / 255
                #expect((TF.encoded(TF.linear(single)) * 255).rounded() == Float(level))
                #expect(abs(Double(TF.linear(single)) - TF.linear(double)) < 1e-6)
            }
        }

        @Test
        func `nothing is clamped: a component outside 0…1 follows the same two pieces`() {
            #expect(TF.linear(-0.5) == -0.5 / TF.linearSlope)
            #expect(TF.encoded(-0.5) == -0.5 * TF.linearSlope)
            #expect(TF.linear(2.0) > 1 && TF.encoded(2.0) > 1)
            #expect(TF.linear(0.5) > 0.2140 && TF.linear(0.5) < 0.2141)
        }
    }
}
