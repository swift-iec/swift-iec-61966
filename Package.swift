// swift-tools-version: 6.2

import PackageDescription

// IEC 61966: Multimedia systems and equipment — Colour measurement and management
let package = Package(
    name: "swift-iec-61966",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(name: "IEC 61966", targets: ["IEC 61966"]),
        .library(name: "IEC 61966 Shared", targets: ["IEC 61966 Shared"]),
        .library(name: "IEC 61966 2-1", targets: ["IEC 61966 2-1"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-standards/swift-iso-9899", from: "0.2.1"),
    ],
    targets: [
        // MARK: - Shared
        .target(name: "IEC 61966 Shared"),

        // MARK: - Part 2-1: sRGB
        .target(
            name: "IEC 61966 2-1",
            dependencies: [
                "IEC 61966 Shared",
                .product(name: "ISO 9899", package: "swift-iso-9899")
            ]
        ),

        // MARK: - High-level API (exports all parts)
        .target(
            name: "IEC 61966",
            dependencies: [
                "IEC 61966 Shared",
                "IEC 61966 2-1",
            ]
        ),

        // MARK: - Tests
        .testTarget(
            name: "IEC 61966 Tests",
            dependencies: ["IEC 61966"]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin].contains(target.type) {
    target.swiftSettings = (target.swiftSettings ?? []) + [
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
    ]
}
