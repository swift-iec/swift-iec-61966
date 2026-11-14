# swift-iec-61966

Use this package when you need sRGB colours as IEC 61966-2-1 defines them: gamma-encoded components, the transfer function to and from linear light, 8-bit and hex forms, and HSL and HWB. Start from `IEC_61966.SRGB`. To convert between sRGB and other colour spaces such as Oklab or CIE LAB, use swift-color.

## Laws

- An `IEC_61966.SRGB` component is always in 0...1. Every way of setting one, the initializers, assignment, compound assignment and `inout` access, clamps the value, and NaN becomes 0.
- The component types such as `IEC_61966.Red`, `IEC_61966.Saturation` and `IEC_61966.LinearLight` come two ways. The throwing initializer refuses a value outside 0...1, including NaN and infinity. The `clamping:` initializer clamps it and turns NaN into 0.
- `IEC_61966.Hue` holds degrees in 0..<360. The throwing initializer refuses anything else, including 360, and `IEC_61966.Hue.init(normalizing:)` wraps any finite angle into the range.
- 8-bit values are divided by 255 on the way in, with out-of-range values clamped, and rounded to the nearest integer on the way out.
- `IEC_61966.SRGB.init(hex:)` reads three or six hex digits, with or without a leading `#` and surrounding whitespace, and gives nil for anything else. Three digits scale each digit by 15. `IEC_61966.SRGB.hex` always writes `#` and six uppercase digits.
- `SRGB.TransferFunction.linear(_:)` and `encoded(_:)` are the piecewise transfer function as plain functions of one component, in `Double` and in `Float`, clamping nothing; the component types below go through them.
- Conversion to linear light uses the sRGB piecewise transfer function. Encoding back meets at the linear threshold, maps 0 and 1 to themselves, and never decreases.
- `SRGB.Level` is the 8-bit encoding of a component taken straight from and back to linear light, for pixel buffers. `SRGB.Level.encoded(_:)` of a `Double` or `Float` gives the `UInt8` level, equal for every input to `TransferFunction.encoded(x) * 255` rounded with halves up and clamped, worked in double precision for a `Float` too: NaN and everything at or below 0 give 0, everything at or above 1 gives 255. It is a table lookup and one comparison, with no power function. `SRGB.Level.linear(_:)` gives the linear light of a level, `TransferFunction.linear(Double(level) / 255)`, as `Double` or rounded to `Float`; it is overloaded on its result, so the call needs a type from its context. `r255` and its siblings are the same 8-bit encoding of a component that is already encoded.
- `SRGB.Matrix.forward` (CIE XYZ, D65 with white at Y = 1, to linear sRGB components) and `SRGB.Matrix.reverse` (back) are the standard's matrices as rows, with the four decimals it prints; they are each other's inverse only to about 5e-4.
