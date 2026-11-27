// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-iec-61966",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(name: "IEC 61966", targets: ["IEC 61966"]),
        .library(name: "IEC 61966 Shared", targets: ["IEC 61966 Shared"]),
        .library(name: "IEC 61966 2-1", targets: ["IEC 61966 2-1"]),
        .library(name: "IEC 61966 Pixel", targets: ["IEC 61966 Pixel"]),
    ],
    traits: [
        .trait(name: "Pixel", description: "IEC 61966 Pixel: swift-pixel's encoded pixel from and to linear light through sRGB levels")
    ],
    dependencies: [
        .package(url: "https://github.com/swift-iec/swift-iec.git", branch: "main"),
        .package(url: "https://github.com/swift-iso/swift-iso-9899.git", branch: "main"),
        .package(
            url: "https://github.com/swift-atoms/swift-ascii.git",
            branch: "main"
        ),
        .package(url: "https://github.com/swift-molecules/swift-pixel.git", branch: "main"),
    ],
    targets: [

        .target(
            name: "IEC 61966 Shared",
            dependencies: [.product(name: "IEC", package: "swift-iec")]
        ),

        .target(
            name: "IEC 61966 2-1",
            dependencies: [
                .target(name: "IEC 61966 Shared"),
                .product(name: "ISO 9899", package: "swift-iso-9899"),
                .product(name: "ASCII", package: "swift-ascii"),
            ]
        ),

        .target(
            name: "IEC 61966",
            dependencies: [
                .target(name: "IEC 61966 Shared"),
                .target(name: "IEC 61966 2-1"),
            ]
        ),

        .target(
            name: "IEC 61966 Pixel",
            dependencies: [
                .target(name: "IEC 61966"),
                .product(name: "Pixel", package: "swift-pixel"),
            ]
        ),

        .testTarget(
            name: "IEC 61966 Tests",
            dependencies: [
                .target(name: "IEC 61966")
            ]
        ),

        .testTarget(
            name: "IEC 61966 Pixel Tests",
            dependencies: [
                .target(name: "IEC 61966"),
                .target(name: "IEC 61966 Pixel"),
                .product(name: "Pixel", package: "swift-pixel"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    target.swiftSettings =
        (target.swiftSettings ?? []) + [
            .strictMemorySafety(),
            .enableUpcomingFeature("ExistentialAny"),
            .enableUpcomingFeature("InternalImportsByDefault"),
            .enableUpcomingFeature("MemberImportVisibility"),
            .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
            .enableUpcomingFeature("InferIsolatedConformances"),
            .enableExperimentalFeature("Lifetimes"),
            .treatAllWarnings(as: .error),
        ]
}
