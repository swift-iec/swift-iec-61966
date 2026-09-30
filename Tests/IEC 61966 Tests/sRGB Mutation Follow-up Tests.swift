import IEC_61966
import Testing

@Suite
struct `sRGB mutation follow-up` {
    typealias sRGB = IEC_61966.`2`.`1`.sRGB

    @Test
    func `out-of-range 8-bit components are normalized`() {
        let color = sRGB(r255: -1, g255: 256, b255: 128)
        #expect(color == sRGB(r: 0, g: 1, b: 128.0 / 255.0))
    }

    @Test
    func `8-bit endpoints and interior values are exact`() {
        #expect(sRGB(r255: 0, g255: 255, b255: 51) == sRGB(r: 0, g: 1, b: 0.2))
    }

    static var channels: [WritableKeyPath<sRGB, Double>] { [\.r, \.g, \.b] }
    static let cases: [(Double, Double)] = [
        (.nan, 0), (.infinity, 1), (-.infinity, 0), (-0.5, 0), (1.5, 1), (0.3, 0.3), (0, 0), (1, 1),
    ]

    @Test(arguments: 0..<3, 0..<8)
    func `assigning to one channel normalizes it and preserves the others`(_ channel: Int, _ index: Int) {
        let keyPath = Self.channels[channel]
        let (value, expected) = Self.cases[index]
        var color = sRGB(r: 0.25, g: 0.5, b: 0.75)
        let original = color

        color[keyPath: keyPath] = value

        #expect(color[keyPath: keyPath] == expected)
        for other in Self.channels where other != keyPath {
            #expect(color[keyPath: other] == original[keyPath: other])
        }
    }

    @Test(arguments: 0..<3)
    func `compound assignment normalizes the result`(_ channel: Int) {
        let keyPath = Self.channels[channel]
        var color = sRGB(r: 0.5, g: 0.5, b: 0.5)

        color[keyPath: keyPath] += 2
        #expect(color[keyPath: keyPath] == 1)

        color[keyPath: keyPath] -= 5
        #expect(color[keyPath: keyPath] == 0)
    }

    @Test(arguments: 0..<3)
    func `an inout mutation normalizes the result`(_ channel: Int) {
        let keyPath = Self.channels[channel]
        var color = sRGB(r: 0.5, g: 0.5, b: 0.5)

        func poison(_ component: inout Double) { component = .nan }
        poison(&color[keyPath: keyPath])

        #expect(color[keyPath: keyPath] == 0)
    }
}
