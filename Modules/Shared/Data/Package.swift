// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Data",
    platforms: [
        .iOS(.v26)
    ],
    products: [
        .library(
            name: "Data",
            targets: ["Data"]
        )
    ],
    dependencies: [
        .package(path: "../Config"),
        .package(path: "../Entities"),
        .package(path: "../Interfaces"),
        .package(path: "../Networking"),
        .package(path: "../Persistence"),
        .package(url: "https://github.com/hmlongco/Factory.git", from: "2.5.3")
    ],
    targets: [
        .target(
            name: "Data",
            dependencies: ["Config", "Entities", "Interfaces", "Networking", "Persistence", "Factory"]
        )
    ]
)
