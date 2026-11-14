public import IEC_61966_Shared

extension IEC_61966.`2`.`1`.SRGB {

    /// The standard's matrices between CIE 1931 XYZ, D65, with the white's Y at 1, and linear sRGB components,
    /// as rows of three, with the four decimals IEC 61966-2-1 prints. The two are inverses only as far as those
    /// digits go.
    public enum Matrix {}
}

extension IEC_61966.`2`.`1`.SRGB.Matrix {

    /// The forward transformation, CIE XYZ to linear R, G and B: `r = 3.2406 x − 1.5372 y − 0.4986 z`, and so on.
    public static let forward: [[Double]] = [
        [3.2406, -1.5372, -0.4986],
        [-0.9689, 1.8758, 0.0415],
        [0.0557, -0.2040, 1.0570],
    ]

    /// The reverse transformation, linear R, G and B to CIE XYZ: `x = 0.4124 r + 0.3576 g + 0.1805 b`, and so on.
    public static let reverse: [[Double]] = [
        [0.4124, 0.3576, 0.1805],
        [0.2126, 0.7152, 0.0722],
        [0.0193, 0.1192, 0.9505],
    ]
}
