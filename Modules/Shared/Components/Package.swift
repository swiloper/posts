// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Components",
    platforms: [
        .iOS(.v26)
    ],
    products: [
        .library(
            name: "Components",
            targets: ["Components"]
        )
    ],
    dependencies: [
        .package(path: "../Files"),
        .package(path: "../Entities"),
        .package(url: "https://github.com/steipete/Demark.git", from: "1.1.0"),
        .package(url: "https://github.com/hmlongco/Factory.git", from: "2.5.3"),
        .package(url: "https://github.com/kean/Nuke.git", from: "12.1.6")
    ],
    targets: [
        .target(
            name: "Components",
            dependencies: [
                "Files",
                "Entities",
                "Demark",
                "Factory",
                .product(name: "Nuke", package: "Nuke"),
                .product(name: "NukeUI", package: "Nuke")
            ]
        )
    ]
)
