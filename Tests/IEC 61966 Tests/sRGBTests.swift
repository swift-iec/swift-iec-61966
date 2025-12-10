// sRGBTests.swift

import Testing
import IEC_61966

@Suite("sRGB Tests")
struct sRGBTests {

    @Test("Create from RGB components")
    func rgbComponents() {
        let color = IEC_61966.sRGB(r: 1, g: 0.5, b: 0.25)
        #expect(color.r == 1)
        #expect(color.g == 0.5)
        #expect(color.b == 0.25)
    }

    @Test("Create grayscale")
    func grayscale() {
        let gray = IEC_61966.sRGB(gray: 0.5)
        #expect(gray.r == 0.5)
        #expect(gray.g == 0.5)
        #expect(gray.b == 0.5)
    }

    @Test("8-bit components")
    func eightBitComponents() {
        let color = IEC_61966.sRGB(r255: 255, g255: 128, b255: 0)
        #expect(color.r255 == 255)
        #expect(color.g255 == 128)
        #expect(color.b255 == 0)
    }

    @Test("Hex string parsing")
    func hexParsing() {
        let color = IEC_61966.sRGB(hex: "#FF8000")
        #expect(color != nil)
        #expect(color?.r255 == 255)
        #expect(color?.g255 == 128)
        #expect(color?.b255 == 0)
    }

    @Test("Hex string output")
    func hexOutput() {
        let color = IEC_61966.sRGB(r255: 255, g255: 128, b255: 0)
        #expect(color.hex == "#FF8000")
    }

    @Test("HSL to RGB - pure red")
    func hslToRgbRed() {
        let red = IEC_61966.sRGB(h: 0, s: 1, l: 0.5)
        #expect(red.r255 == 255)
        #expect(red.g255 == 0)
        #expect(red.b255 == 0)
    }

    @Test("HSL to RGB - pure green")
    func hslToRgbGreen() {
        let green = IEC_61966.sRGB(h: 120, s: 1, l: 0.5)
        #expect(green.r255 == 0)
        #expect(green.g255 == 255)
        #expect(green.b255 == 0)
    }

    @Test("HSL to RGB - pure blue")
    func hslToRgbBlue() {
        let blue = IEC_61966.sRGB(h: 240, s: 1, l: 0.5)
        #expect(blue.r255 == 0)
        #expect(blue.g255 == 0)
        #expect(blue.b255 == 255)
    }

    @Test("HSL roundtrip")
    func hslRoundtrip() {
        let original = IEC_61966.sRGB(r: 0.8, g: 0.4, b: 0.2)
        let hsl = original.hsl
        let converted = IEC_61966.sRGB(
            h: hsl.hue.degrees,
            s: hsl.saturation.value,
            l: hsl.lightness.value
        )

        #expect(abs(original.r - converted.r) < 0.01)
        #expect(abs(original.g - converted.g) < 0.01)
        #expect(abs(original.b - converted.b) < 0.01)
    }

    @Test("Common colors")
    func commonColors() {
        #expect(IEC_61966.sRGB.black == IEC_61966.sRGB(r: 0, g: 0, b: 0))
        #expect(IEC_61966.sRGB.white == IEC_61966.sRGB(r: 1, g: 1, b: 1))
        #expect(IEC_61966.sRGB.red == IEC_61966.sRGB(r: 1, g: 0, b: 0))
        #expect(IEC_61966.sRGB.green == IEC_61966.sRGB(r: 0, g: 1, b: 0))
        #expect(IEC_61966.sRGB.blue == IEC_61966.sRGB(r: 0, g: 0, b: 1))
    }
}
