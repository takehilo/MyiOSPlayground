// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "AppFeature",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "AppFeature",
            targets: ["AppFeature"]
        ),
    ],
    dependencies: [
        .package(path: "SharedModel"),
        .package(path: "LoginFeature"),
        .package(path: "HomeFeature"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.9.2"),
    ],
    targets: [
        .target(
            name: "AppFeature",
            dependencies: [
                "SharedModel",
                "LoginFeature",
                "HomeFeature",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .testTarget(
            name: "AppFeatureTests",
            dependencies: ["AppFeature"]
        ),
    ]
)
