public import IEC_61966_Shared

extension IEC.`61966`.`2`.`1` {

    public struct HWB: Sendable, Hashable {

        public let hue: Hue

        public let whiteness: Whiteness

        public let blackness: Blackness

        public init(
            hue: Hue,
            whiteness: Whiteness,
            blackness: Blackness
        ) {
            self.hue = hue
            self.whiteness = whiteness
            self.blackness = blackness
        }
    }
}

extension IEC.`61966`.`2`.`1`.HWB {

    public init(h: Double, w: Double, b: Double) {
        self.hue = Hue(normalizing: h)
        self.whiteness = Whiteness(clamping: w)
        self.blackness = Blackness(clamping: b)
    }
}

extension IEC.`61966`.`2`.`1`.HWB {

    public init(_ srgb: IEC.`61966`.`2`.`1`.SRGB) {
        let hwb = srgb.hwb
        self.hue = hwb.hue
        self.whiteness = hwb.whiteness
        self.blackness = hwb.blackness
    }

    public var srgb: IEC.`61966`.`2`.`1`.SRGB {
        IEC.`61966`.`2`.`1`.SRGB(
            hue: hue,
            whiteness: whiteness,
            blackness: blackness
        )
    }
}

extension IEC.`61966`.`2`.`1`.HWB {

    public init(_ hsl: IEC.`61966`.`2`.`1`.HSL) {
        self.init(hsl.srgb)
    }

    public var hsl: IEC.`61966`.`2`.`1`.HSL {
        IEC.`61966`.`2`.`1`.HSL(srgb)
    }
}

extension IEC.`61966`.`2`.`1`.HWB {

    public var h: Double { hue.degrees }

    public var w: Double { whiteness.value }

    public var b: Double { blackness.value }
}
