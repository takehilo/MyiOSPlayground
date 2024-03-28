// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "LoginFeature",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "LoginFeature",
            targets: ["LoginFeature"]
        ),
    ],
    dependencies: [
        .package(path: "SharedModel"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.9.2"),
    ],
    targets: [
        .target(
            name: "LoginFeature",
            dependencies: [
                "SharedModel",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .testTarget(
            name: "LoginFeatureTests",
            dependencies: ["LoginFeature"]
        ),
    ]
)
