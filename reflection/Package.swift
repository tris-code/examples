// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "reflection-example",
    dependencies: [
        .package(
            url: "https://github.com/tris-foundation/reflection.git",
            from: "0.4.0"
        )
    ],
    targets: [
        .target(name: "main", dependencies: ["Reflection"])
    ]
)
