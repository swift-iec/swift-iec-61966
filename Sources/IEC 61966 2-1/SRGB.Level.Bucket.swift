public import IEC_61966_Shared

extension IEC_61966.`2`.`1`.SRGB.Level {

    /// One bucket of linear light: the values whose sign, exponent and top eight significand bits are the same.
    /// The values from 2⁻¹³ up to 1 make 13 binades of 256 buckets each. The level is that of the bucket's
    /// first value, and `threshold` is the first value in the bucket with the next level, or +∞ when there is
    /// none. Two levels are never closer than a relative 0.9 % of linear light, wider than a bucket's 0.4 %,
    /// so no bucket holds a second threshold; building the table checks it.
    @usableFromInline
    struct Bucket<Value: BinaryFloatingPoint & Sendable>: Sendable {

        @usableFromInline
        let threshold: Value

        @usableFromInline
        let level: UInt8
    }
}

extension IEC_61966.`2`.`1`.SRGB.Level.Bucket {

    /// The first value with a bucket; every value below it has level 0.
    @usableFromInline
    static var lowest: Value { 0x1p-13 }

    /// The buckets in order, built from `level`, the plain path of a value in this precision.
    static func all(_ level: (Value) -> UInt8) -> [Self] {
        var buckets: [Self] = []
        buckets.reserveCapacity(13 * 256)
        (-13 ... -1).forEach { exponent in
            let binade = Value(sign: .plus, exponent: Value.Exponent(exponent), significand: 1)
            (0..<256).forEach { step in
                let start = binade * (1 + Value(step) / 256)
                let last = (binade * (1 + Value(step + 1) / 256)).nextDown
                buckets.append(Self(start: start, last: last, level))
            }
        }
        return buckets
    }

    /// The bucket from `start` to `last`, both included: the level of `start`, and the first value of the next
    /// level found by bisection.
    init(start: Value, last: Value, _ level: (Value) -> UInt8) {
        let first = level(start)
        guard level(last) != first else {
            self.init(threshold: .infinity, level: first)
            return
        }
        precondition(level(last) == first + 1, "a bucket holds one threshold at most")
        var below = start
        var above = last
        while below.nextUp < above {
            let middle = below + (above - below) / 2
            if level(middle) > first { above = middle } else { below = middle }
        }
        self.init(threshold: above, level: first)
    }
}
