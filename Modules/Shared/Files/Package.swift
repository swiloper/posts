// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Files",
    platforms: [
        .iOS(.v26)
    ],
    products: [
        .library(
            name: "Files",
            targets: ["Files"]
        )
    ],
    dependencies: [
        .package(path: "../Utilities"),
        .package(url: "https://github.com/hmlongco/Factory.git", from: "2.5.3")
    ],
    targets: [
        .target(
            name: "Files",
            dependencies: ["Utilities", "Factory"]
        )
    ]
)
