#if Pixel
    import IEC_61966
    import IEC_61966_Pixel
    import Pixel
    import Testing

    enum `Pixel BGRA Tests` {
        static func bytes(_ pixel: Pixel.BGRA) -> [UInt8] { [pixel.red, pixel.green, pixel.blue, pixel.alpha] }
    }

    extension `Pixel BGRA Tests` {
        @Suite
        struct `An encoded pixel is linear light through sRGB levels` {}
    }

    extension `Pixel BGRA Tests`.`An encoded pixel is linear light through sRGB levels` {
        typealias Tests = `Pixel BGRA Tests`

        @Test func `nothing is a clear pixel, and opaque black and white are themselves`() {
            #expect(Tests.bytes(Pixel.BGRA(linear: 0, green: 0, blue: 0, alpha: 0)) == [0, 0, 0, 0])
            #expect(Tests.bytes(Pixel.BGRA(linear: 0, green: 0, blue: 0, alpha: 1)) == [0, 0, 0, 255])
            #expect(Tests.bytes(Pixel.BGRA(linear: 1, green: 1, blue: 1, alpha: 1)) == [255, 255, 255, 255])
        }

        @Test func `each colour is its own channel, encoded from linear light: linear 0.5 is sRGB level 188`() {
            #expect(Tests.bytes(Pixel.BGRA(linear: 0.5, green: 0, blue: 0, alpha: 1)) == [188, 0, 0, 255])
            #expect(Tests.bytes(Pixel.BGRA(linear: 0, green: 0.5, blue: 0, alpha: 1)) == [0, 188, 0, 255])
            #expect(Tests.bytes(Pixel.BGRA(linear: 0, green: 0, blue: 0.5, alpha: 1)) == [0, 0, 188, 255])
        }

        @Test func `a colour under half alpha is encoded as its own colour and then halved`() {
            #expect(Tests.bytes(Pixel.BGRA(linear: 0.5, green: 0, blue: 0, alpha: 0.5)) == [128, 0, 0, 128])
            #expect(Tests.bytes(Pixel.BGRA(linear: 0.25, green: 0, blue: 0, alpha: 0.5)) == [94, 0, 0, 128])
        }

        @Test func `light brighter than white is white, less than none is none, and what is not a number is nothing`() {
            #expect(Tests.bytes(Pixel.BGRA(linear: 4, green: 9, blue: .infinity, alpha: 1)) == [255, 255, 255, 255])
            #expect(Tests.bytes(Pixel.BGRA(linear: -1, green: -0.5, blue: -.infinity, alpha: 1)) == [0, 0, 0, 255])
            #expect(Tests.bytes(Pixel.BGRA(linear: .nan, green: .nan, blue: .nan, alpha: 1)) == [0, 0, 0, 255])
            #expect(Tests.bytes(Pixel.BGRA(linear: 1, green: 1, blue: 1, alpha: .nan)) == [0, 0, 0, 0])
            #expect(Tests.bytes(Pixel.BGRA(linear: 1, green: 1, blue: 1, alpha: 7)) == [255, 255, 255, 255])
            #expect(Tests.bytes(Pixel.BGRA(linear: 1, green: 1, blue: 1, alpha: -1)) == [0, 0, 0, 0])
        }

        @Test func `no colour comes out above its alpha, whatever goes in`() {
            let values: [Float] = [-1, 0, 0.001, 0.0019, 0.002, 0.1, 0.25, 0.3333, 0.5, 0.75, 0.999, 1, 1.5, .infinity, .nan]
            var above = 0
            for alpha in values {
                for colour in values {
                    let pixel = Pixel.BGRA(linear: colour, green: colour * 0.5, blue: colour * alpha, alpha: alpha)
                    if Pixel.BGRA(blue: pixel.blue, green: pixel.green, red: pixel.red, alpha: pixel.alpha) == nil { above += 1 }
                }
            }
            #expect(above == 0)
        }

        @Test func `every opaque level comes back as itself through its linear light`() {
            let wrong = (UInt8.min...UInt8.max).filter { level in
                let light = Pixel.BGRA.linear(level)
                return Tests.bytes(Pixel.BGRA(linear: light, green: light, blue: light, alpha: 1)) != [level, level, level, 255]
            }
            #expect(wrong.isEmpty, "levels that came back as another level: \(wrong)")
        }

        @Test func `a level's linear light is the sRGB level's`() {
            for level in UInt8.min...UInt8.max {
                let expected: Float = IEC.`61966`.SRGB.Level.linear(level)
                #expect(Pixel.BGRA.linear(level) == expected)
            }
        }
    }
#endif
