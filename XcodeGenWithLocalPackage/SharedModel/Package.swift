// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "SharedModel",
    products: [
        .library(
            name: "SharedModel",
            targets: ["SharedModel"]
        ),
    ],
    targets: [
        .target(
            name: "SharedModel"
        ),
        .testTarget(
            name: "SharedModelTests",
            dependencies: ["SharedModel"]
        ),
    ]
)
