public import IEC_61966_Shared

extension IEC_61966.`2`.`1`.SRGB.Level {

    /// The tables `Level` reads, each built once on first use.
    @usableFromInline
    enum Table {}
}

extension IEC_61966.`2`.`1`.SRGB.Level.Table {

    @usableFromInline
    static let double = IEC_61966.`2`.`1`.SRGB.Level.Bucket<Double>.all { plain($0) }

    @usableFromInline
    static let float = IEC_61966.`2`.`1`.SRGB.Level.Bucket<Float>.all { plain(Double($0)) }

    @usableFromInline
    static let linear: [Double] = (0...255).map { level in
        IEC_61966.`2`.`1`.SRGB.TransferFunction.linear(Double(level) / 255)
    }

    @usableFromInline
    static let single: [Float] = linear.map { Float($0) }

    /// The plain path the tables are built from: one power function per value.
    static func plain(_ linear: Double) -> UInt8 {
        let scaled = (IEC_61966.`2`.`1`.SRGB.TransferFunction.encoded(linear) * 255).rounded()
        guard scaled >= 0 else { return 0 }
        guard scaled < 255 else { return 255 }
        return UInt8(scaled)
    }
}
