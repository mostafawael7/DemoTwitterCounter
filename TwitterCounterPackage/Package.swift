// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "TwitterCounter",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "TwitterCounter",
            targets: ["TwitterCounter"]
        )
    ],
    targets: [
        .target(
            name: "TwitterCounter",
            dependencies: []
        )
    ]
)
