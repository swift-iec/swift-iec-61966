public import IEC_61966_Shared

extension IEC_61966.`2`.`1`.sRGB {

    public init(
        hue: IEC_61966.`2`.`1`.Hue,
        saturation: IEC_61966.`2`.`1`.Saturation,
        lightness: IEC_61966.`2`.`1`.Lightness
    ) {
        let h = hue.degrees
        let s = saturation.value
        let l = lightness.value

        if s == 0 {

            self.init(gray: l)
            return
        }

        let q = l < 0.5 ? l * (1 + s) : l + s - l * s
        let p = 2 * l - q

        let hNormalized = h / 360.0

        let r = Self.hueToRgb(p: p, q: q, t: hNormalized + 1.0 / 3.0)
        let g = Self.hueToRgb(p: p, q: q, t: hNormalized)
        let b = Self.hueToRgb(p: p, q: q, t: hNormalized - 1.0 / 3.0)
        self.init(r: r, g: g, b: b)
    }

    public init(h: Double, s: Double, l: Double) {
        self.init(
            hue: IEC_61966.`2`.`1`.Hue(normalizing: h),
            saturation: IEC_61966.`2`.`1`.Saturation(clamping: s),
            lightness: IEC_61966.`2`.`1`.Lightness(clamping: l)
        )
    }

    private static func hueToRgb(p: Double, q: Double, t: Double) -> Double {
        var t = t
        if t < 0 { t += 1 }
        if t > 1 { t -= 1 }

        if t < 1.0 / 6.0 {
            return p + (q - p) * 6.0 * t
        }
        if t < 1.0 / 2.0 {
            return q
        }
        if t < 2.0 / 3.0 {
            return p + (q - p) * (2.0 / 3.0 - t) * 6.0
        }
        return p
    }
}

extension IEC_61966.`2`.`1`.sRGB {

    public var hsl:
        (
            hue: IEC_61966.`2`.`1`.Hue,
            saturation: IEC_61966.`2`.`1`.Saturation,
            lightness: IEC_61966.`2`.`1`.Lightness
        )
    {
        let (h, s, l) = hslValues
        return (
            hue: IEC_61966.`2`.`1`.Hue(normalizing: h),
            saturation: IEC_61966.`2`.`1`.Saturation(clamping: s),
            lightness: IEC_61966.`2`.`1`.Lightness(clamping: l)
        )
    }

    public var hslValues: (h: Double, s: Double, l: Double) {
        let maxC = max(r, g, b)
        let minC = min(r, g, b)
        let delta = maxC - minC

        let l = (maxC + minC) / 2.0

        if delta == 0 {
            return (h: 0, s: 0, l: l)
        }

        let s =
            l > 0.5
            ? delta / (2.0 - maxC - minC)
            : delta / (maxC + minC)

        var h: Double
        switch maxC {
        case r:
            h = ((g - b) / delta).truncatingRemainder(dividingBy: 6)

        case g:
            h = (b - r) / delta + 2

        default:
            h = (r - g) / delta + 4
        }

        h *= 60
        if h < 0 { h += 360 }

        return (h: h, s: s, l: l)
    }
}
