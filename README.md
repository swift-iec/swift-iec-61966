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
