// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "Interfaces",
    products: [
        .library(
            name: "Interfaces",
            targets: ["Interfaces"]),
    ],
    targets: [
        .target(
            name: "Interfaces"),
        .testTarget(
            name: "InterfacesTests",
            dependencies: ["Interfaces"]
        ),
    ]
)
