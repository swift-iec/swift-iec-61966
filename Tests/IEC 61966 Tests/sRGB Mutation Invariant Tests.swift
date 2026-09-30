import Testing

import IEC_61966

@Suite
struct `sRGB mutation invariant` {
    @Test
    func `assigning a component applies the constructor's normalization`() {
        var color = IEC_61966.`2`.`1`.sRGB(r: 0.5, g: 0.5, b: 0.5)
        color.r = .nan
        color.g = 2
        color.b = -.infinity
        #expect(color == IEC_61966.`2`.`1`.sRGB(r: 0, g: 1, b: 0))
    }

    @Test
    func `assigning an in-range component keeps it`() {
        var color = IEC_61966.`2`.`1`.sRGB(r: 0, g: 0, b: 0)
        color.g = 0.25
        #expect(color.g == 0.25)
    }

    @Test(arguments: [(Double.nan, 0.0), (1.5, 1.0), (-0.5, 0.0), (.infinity, 1.0), (0.4, 0.4)])
    func `a gray value is normalized like any component`(_ gray: Double, _ expected: Double) {
        let color = IEC_61966.`2`.`1`.sRGB(gray: gray)
        #expect(color == IEC_61966.`2`.`1`.sRGB(r: expected, g: expected, b: expected))
    }
}
