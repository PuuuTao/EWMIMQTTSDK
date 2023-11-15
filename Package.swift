// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EWMIMQTTSDK",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "EWMIMQTTSDK",
            type: .dynamic,
            targets: ["EWMIMQTTSDK"]),
    ],
    dependencies: [
            .package(url: "https://github.com/emqx/CocoaMQTT", from: "2.1.8"),
        ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "EWMIMQTTSDK",
            dependencies: [ "CocoaMQTT" ]),
        .testTarget(
            name: "EWMIMQTTSDKTests",
            dependencies: ["EWMIMQTTSDK"]),
    ]
)
