import IEC_61966
import Testing

@Suite
struct `sRGB transfer function boundaries` {
    private typealias Linear = IEC_61966.`2`.`1`.LinearLight
    private typealias TF = IEC_61966.`2`.`1`.sRGB.TransferFunction

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
}
