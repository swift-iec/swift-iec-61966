public import IEC_61966_Shared

extension IEC_61966.`2`.`1`.sRGB {

    public init(
        hue: IEC_61966.`2`.`1`.Hue,
        whiteness: IEC_61966.`2`.`1`.Whiteness,
        blackness: IEC_61966.`2`.`1`.Blackness
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
            saturation: IEC_61966.`2`.`1`.Saturation(clamping: 1),
            lightness: IEC_61966.`2`.`1`.Lightness(clamping: 0.5)
        )

        let scale = 1 - w - b
        self.r = base.r * scale + w
        self.g = base.g * scale + w
        self.b = base.b * scale + w
    }

    public init(hue: Double, whiteness: Double, blackness: Double) {
        self.init(
            hue: IEC_61966.`2`.`1`.Hue(normalizing: hue),
            whiteness: IEC_61966.`2`.`1`.Whiteness(clamping: whiteness),
            blackness: IEC_61966.`2`.`1`.Blackness(clamping: blackness)
        )
    }
}

extension IEC_61966.`2`.`1`.sRGB {

    public var hwb:
        (
            hue: IEC_61966.`2`.`1`.Hue,
            whiteness: IEC_61966.`2`.`1`.Whiteness,
            blackness: IEC_61966.`2`.`1`.Blackness
        )
    {
        let (h, w, b) = hwbValues
        return (
            hue: IEC_61966.`2`.`1`.Hue(normalizing: h),
            whiteness: IEC_61966.`2`.`1`.Whiteness(clamping: w),
            blackness: IEC_61966.`2`.`1`.Blackness(clamping: b)
        )
    }

    public var hwbValues: (h: Double, w: Double, b: Double) {
        let hsl = self.hslValues
        let w = min(r, g, b)
        let b = 1 - max(r, g, b)
        return (h: hsl.h, w: w, b: b)
    }
}
