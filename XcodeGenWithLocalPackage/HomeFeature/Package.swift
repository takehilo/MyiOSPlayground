// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "HomeFeature",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "HomeFeature",
            targets: ["HomeFeature"]
        ),
    ],
    dependencies: [
        .package(path: "SharedModel"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.9.2"),
    ],
    targets: [
        .target(
            name: "HomeFeature",
            dependencies: [
                "SharedModel",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .testTarget(
            name: "HomeFeatureTests",
            dependencies: ["HomeFeature"]
        ),
    ]
)
