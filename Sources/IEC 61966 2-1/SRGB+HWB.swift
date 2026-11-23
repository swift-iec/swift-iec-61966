public import IEC_61966_Shared

extension IEC.`61966`.`2`.`1`.SRGB {

    public init(
        hue: IEC.`61966`.`2`.`1`.Hue,
        whiteness: IEC.`61966`.`2`.`1`.Whiteness,
        blackness: IEC.`61966`.`2`.`1`.Blackness
    ) {
        var w = whiteness.value
        var b = blackness.value

        let total = w + b
        if total >= 1 {
            w /= total
            b /= total
        }

        let base = Self(
            hue: hue,
            saturation: IEC.`61966`.`2`.`1`.Saturation(clamping: 1),
            lightness: IEC.`61966`.`2`.`1`.Lightness(clamping: 0.5)
        )

        let scale = 1 - w - b
        self.init(r: base.r * scale + w, g: base.g * scale + w, b: base.b * scale + w)
    }

    public init(hue: Double, whiteness: Double, blackness: Double) {
        self.init(
            hue: IEC.`61966`.`2`.`1`.Hue(normalizing: hue),
            whiteness: IEC.`61966`.`2`.`1`.Whiteness(clamping: whiteness),
            blackness: IEC.`61966`.`2`.`1`.Blackness(clamping: blackness)
        )
    }
}

extension IEC.`61966`.`2`.`1`.SRGB {

    public var hwb:
        (
            hue: IEC.`61966`.`2`.`1`.Hue,
            whiteness: IEC.`61966`.`2`.`1`.Whiteness,
            blackness: IEC.`61966`.`2`.`1`.Blackness
        )
    {
        let (h, w, b) = hwbValues
        return (
            hue: IEC.`61966`.`2`.`1`.Hue(normalizing: h),
            whiteness: IEC.`61966`.`2`.`1`.Whiteness(clamping: w),
            blackness: IEC.`61966`.`2`.`1`.Blackness(clamping: b)
        )
    }

    public var hwbValues: (h: Double, w: Double, b: Double) {
        let hsl = self.hslValues
        let w = min(r, g, b)
        let b = 1 - max(r, g, b)
        return (h: hsl.h, w: w, b: b)
    }
}
