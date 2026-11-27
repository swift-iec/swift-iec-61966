#if Pixel
    import IEC_61966
    public import Pixel

    extension Pixel::Pixel.BGRA {

        public init(linear red: Float, green: Float, blue: Float, alpha: Float) {
            let alpha = Self.unit(alpha)
            let cover = Self.level(alpha)
            self.init(
                unchecked: Self.scaled(Self.encoded(blue, under: alpha), by: cover),
                green: Self.scaled(Self.encoded(green, under: alpha), by: cover),
                red: Self.scaled(Self.encoded(red, under: alpha), by: cover),
                alpha: cover
            )
        }

        public static func linear(_ level: UInt8) -> Float {
            IEC.`61966`.SRGB.Level.linear(level)
        }

        static func scaled(_ level: UInt8, by cover: UInt8) -> UInt8 {
            UInt8((UInt(level) * UInt(cover) * 2 + 255) / 510)
        }

        static func unit(_ value: Float) -> Float {
            value > 0 ? Swift.min(value, 1) : 0
        }

        static func level(_ value: Float) -> UInt8 {
            UInt8((unit(value) * 255 + 0.5).rounded(.down))
        }

        static func encoded(_ component: Float, under alpha: Float) -> UInt8 {
            alpha > 0 ? IEC.`61966`.SRGB.Level.encoded(component / alpha) : 0
        }
    }
#endif
