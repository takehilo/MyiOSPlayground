// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "AppPackage",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "AppFeature", targets: ["AppFeature"])
    ],
    dependencies: [
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
        .target(
            name: "HomeFeature",
            dependencies: ["SharedModel"]
        ),
        .testTarget(
            name: "HomeFeatureTests",
            dependencies: ["HomeFeature"]
        ),
        .target(
            name: "LoginFeature",
            dependencies: ["SharedModel"]
        ),
        .testTarget(
            name: "LoginFeatureTests",
            dependencies: ["LoginFeature"]
        ),
        .target(
            name: "SharedModel"
        ),
    ]
)
