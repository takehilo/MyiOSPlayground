// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "TCAUIKitStackBasedNavigation",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "AppFeature", targets: ["AppFeature"]),
        .library(name: "UserListFeature", targets: ["UserListFeature"]),
        .library(name: "UserDetailFeature", targets: ["UserDetailFeature"]),
        .library(name: "FollowerListFeature", targets: ["FollowerListFeature"])
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.9.2"),
        .package(url: "https://github.com/pointfreeco/swift-identified-collections", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "SharedModel",
            dependencies: [
                .product(name: "IdentifiedCollections", package: "swift-identified-collections")
            ]
        ),
        .target(
            name: "AppFeature",
            dependencies: [
                "SharedModel",
                "UserListFeature",
                "UserDetailFeature",
                "FollowerListFeature",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .testTarget(
            name: "AppFeatureTests",
            dependencies: ["AppFeature"]
        ),
        .target(
            name: "UserListFeature",
            dependencies: [
                "SharedModel",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .target(
            name: "UserDetailFeature",
            dependencies: [
                "SharedModel",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .target(
            name: "FollowerListFeature",
            dependencies: [
                "SharedModel",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        )
    ]
)
