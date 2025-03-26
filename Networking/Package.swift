// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "Networking",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Networking",
            targets: ["Networking"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apollographql/apollo-ios.git", exact: "1.18.0"),
        .package(path: "Interfaces"),
        .package(path: "PickleAPI")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Networking",
            dependencies: [
                .product(name: "Apollo", package: "apollo-ios"),
                .product(name: "Interfaces", package: "Interfaces"),
                .product(name: "PickleAPI", package: "PickleAPI")
            ]
        ),
        .testTarget(
            name: "NetworkingTests",
            dependencies: ["Networking"]
        ),
    ]
)
