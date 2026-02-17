// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Networking",
    platforms: [
        .iOS(.v26)
    ],
    products: [
        .library(
            name: "Networking",
            targets: ["Networking"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/hmlongco/Factory.git", from: "2.5.3"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.11.1")
    ],
    targets: [
        .target(
            name: "Networking",
            dependencies: ["Factory", "Alamofire"]
        )
    ]
)
