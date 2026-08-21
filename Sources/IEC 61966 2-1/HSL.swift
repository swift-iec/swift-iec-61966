public import IEC_61966_Shared

extension IEC_61966.`2`.`1` {

    public struct HSL: Sendable, Hashable {

        public let hue: Hue

        public let saturation: Saturation

        public let lightness: Lightness

        public init(
            hue: Hue,
            saturation: Saturation,
            lightness: Lightness
        ) {
            self.hue = hue
            self.saturation = saturation
            self.lightness = lightness
        }
    }
}

extension IEC_61966.`2`.`1`.HSL {

    public init(h: Double, s: Double, l: Double) {
        self.hue = Hue(normalizing: h)
        self.saturation = Saturation(clamping: s)
        self.lightness = Lightness(clamping: l)
    }
}

extension IEC_61966.`2`.`1`.HSL {

    public init(_ srgb: IEC_61966.`2`.`1`.sRGB) {
        let hsl = srgb.hsl
        self.hue = hsl.hue
        self.saturation = hsl.saturation
        self.lightness = hsl.lightness
    }

    public var srgb: IEC_61966.`2`.`1`.sRGB {
        IEC_61966.`2`.`1`.sRGB(
            hue: hue,
            saturation: saturation,
            lightness: lightness
        )
    }
}

extension IEC_61966.`2`.`1`.HSL {

    public var h: Double { hue.degrees }

    public var s: Double { saturation.value }

    public var l: Double { lightness.value }
}
