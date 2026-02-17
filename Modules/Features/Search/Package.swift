// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Search",
    platforms: [
        .iOS(.v26)
    ],
    products: [
        .library(
            name: "Search",
            targets: ["Search"]
        )
    ],
    dependencies: [
        .package(path: "../Data"),
        .package(path: "../Entities"),
        .package(path: "../UseCases"),
        .package(path: "../Utilities"),
        .package(path: "../Components")
    ],
    targets: [
        .target(
            name: "Search",
            dependencies: [
                "Data", "Entities", "UseCases", "Utilities", "Components"
            ]
        )
    ]
)
