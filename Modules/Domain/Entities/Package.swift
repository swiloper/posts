// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Entities",
    platforms: [
        .iOS(.v26)
    ],
    products: [
        .library(
            name: "Entities",
            targets: ["Entities"]
        )
    ],
    dependencies: [
        .package(path: "../Utilities")
    ],
    targets: [
        .target(
            name: "Entities",
            dependencies: ["Utilities"]
        )
    ]
)
