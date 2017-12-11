// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "fiber-example",
    dependencies: [
        .package(
            url: "https://github.com/tris-foundation/fiber.git",
            .branch("master"))
    ],
    targets: [
        .target(name: "main", dependencies: ["Fiber"])
    ]
)
