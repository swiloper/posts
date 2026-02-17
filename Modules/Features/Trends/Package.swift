// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Trends",
    platforms: [
        .iOS(.v26)
    ],
    products: [
        .library(
            name: "Trends",
            targets: ["Trends"]
        )
    ],
    dependencies: [
        .package(path: "../Data"),
        .package(path: "../Entities"),
        .package(path: "../UseCases"),
        .package(path: "../Utilities"),
        .package(path: "../Components"),
        .package(path: "../Persistence")
    ],
    targets: [
        .target(
            name: "Trends",
            dependencies: [
                "Data", "Entities", "UseCases", "Utilities", "Components", "Persistence"
            ]
        )
    ]
)
