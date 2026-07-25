# swift-iec-61966

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

The sRGB default colour space of IEC 61966-2-1.

## Standard Reference

- **IEC**: 61966-2-1
- **Title**: Multimedia systems and equipment — Colour measurement and management (sRGB)

## Installation

Add the package to your `Package.swift` dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/swift-iec/swift-iec-61966.git", from: "0.1.3")
]
```

Add the product to a target that needs it:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "IEC 61966", package: "swift-iec-61966")
    ]
)
```

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
