// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "PickleAPI",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_14),
        .tvOS(.v12),
        .watchOS(.v5),
    ],
    products: [
        .library(name: "PickleAPI", targets: ["PickleAPI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apollographql/apollo-ios.git", exact: "1.18.0"),
    ],
    targets: [
        .target(
            name: "PickleAPI",
            dependencies: [
                .product(name: "ApolloAPI", package: "apollo-ios"),
            ],
            path: "./Sources"
        ),
    ]
)
