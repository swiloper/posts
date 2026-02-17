// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UseCases",
    platforms: [
        .iOS(.v26)
    ],
    products: [
        .library(
            name: "UseCases",
            targets: ["UseCases"]
        )
    ],
    dependencies: [
        .package(path: "../Entities"),
        .package(path: "../Interfaces")
    ],
    targets: [
        .target(
            name: "UseCases",
            dependencies: ["Entities", "Interfaces"]
        )
    ]
)
