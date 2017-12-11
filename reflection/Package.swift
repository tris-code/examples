// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "reflection-example",
    dependencies: [
        .package(
            url: "https://github.com/tris-foundation/reflection.git",
            .branch("master"))
    ],
    targets: [
        .target(name: "main", dependencies: ["Reflection"])
    ]
)
